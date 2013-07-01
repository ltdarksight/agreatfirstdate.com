Backbone.StripeToken = Backbone.Model.extend(
  api: Stripe
  error: null
  defaults:
    amount: null

  parse: (resp) ->
    resp.card.number = "••••••••••••" + resp.card.last4
    resp

  validate: (attrs) ->
    if attrs.card

      if attrs.card.number and not attrs.card.last4 and not @api.validateCardNumber(attrs.card.number)
        this.error = ["card_number","Invalid card number"]
        return this.error

      if attrs.card.exp_month and attrs.card.exp_year and not @api.validateExpiry(attrs.card.exp_month.toString(), attrs.card.exp_year.toString())
        this.error = ["card_expiry","Invalid expiration."]
        return this.error

      if attrs.card.cvc and not @api.validateCVC(attrs.card.cvc.toString())
        this.error = ["card_cvc","Invalid CVC"]
        return this.error

    return null

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
        model.trigger "error", model, resp, options
      else
        serverAttrs = model.parse(resp)
        return false  unless model.set(serverAttrs, options)
        onSuccess model, resp, options  if onSuccess
        model.trigger "sync", model, resp, options
)
