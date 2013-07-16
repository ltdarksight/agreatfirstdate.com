Backbone.StripeToken = Backbone.Model.extend(
  api: Stripe
  error: null
  defaults:
    amount: null

  parse: (resp) ->
    resp.card.number = "••••••••••••" + resp.card.last4
    resp

  validate: (validate_attrs) ->
    attrs = validate_attrs.card
    unless attrs
      return { field: "card_number", message: "Invalid card number" }
    console.log 'valid', attrs
    error =
      if (attrs.number and not attrs.last4 and not @api.validateCardNumber(attrs.number))
        field: "card_number"
        message: "Invalid card number"
      else if  (!Stripe.validateExpiry attrs.exp_month, attrs.exp_year)
        field: "card_expiration"
        message: "Invalid expiration."
      else if attrs.cvc and (!Stripe.validateCVC attrs.cvc)
        field: "card_cvc"
        message: "Invalid CVC"
      else
        null

  save: (options) ->
    options = options or {}

    options = _.extend({validate: true}, options);

    if (!this._validate(this.attributes, options))
      return false

    options.error = this.wrapError(options.error, options);
    options.success = @wrapSuccess(options.success, options)
    @api.createToken @attributes.card, @attributes.amount, options.success
    true

  fetch: (options) ->
    options = options or {}

    options.error = this.wrapError(options.error, options);
    options.success = @wrapSuccess(options.success, options)
    @api.getToken @id, options.success

  wrapError: (model, options) ->
    error = options.error
    options.error = (resp) ->
      error model, resp, options  if error
      model.trigger "error", model, resp, options

  wrapSuccess: (onSuccess, options) ->
    model = this
    (status, resp) ->
      if status isnt 200
        options.error model, resp
      else
        serverAttrs = model.parse(resp)
        return false  unless model.set(serverAttrs, options)
        onSuccess model, resp, options  if onSuccess
        model.trigger "sync", model, resp, options
)
