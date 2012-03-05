Agreatfirstdate.Views.User.Settings ||= {}

class Agreatfirstdate.Views.User.Settings.FormView extends Backbone.View
  initialize: (options) ->
    super(options)
    @model = options.user
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @setElement($('#edit_profile'))
#    @model.on 'change:card_number', (model, value)=>
#      console.log model.valid?
#      @$('.verify_').toggle(model.valid?)

    @model.on 'change:card_verified?', @render, this
    @model.on 'change:errors', (model, errors)=>
      @$('.verify_').toggle if !errors && model.get('card_number') != '' && !model.get('card_verified?') then true else false

      @$('span.error_').closest('.control-group').removeClass('error').end().remove()
      _.each errors, (errors, field)->
        $_input = @$(":input[name='#{@paramRoot}[#{field}]']")
        $_input.after(@make("span", {class: "help-inline error_"}, _(errors).first()))
        $_input.closest('.control-group').addClass('error')
      , this
    @cardRelatedFields = @$('#profile_card_number, #profile_card_expiration, #profile_card_cvc, #profile_card_type, #profile_stripe_card_token')

  paramRoot: 'profile'

  events:
    'submit': 'processCard'
    'click .verify_': 'verifyCard'
    'click .change-card_': 'changeCardDetails'
    'click .cancel-card-change_': 'cancelCardChange'
    'keyup #profile_card_number, #profile_card_expiration, #profile_card_cvc, #profile_card_type': 'validateCard'

  validateCard: (e)->
    $(e.currentTarget).trigger('change')
    @model.isValid()

  processCard: (e)->
    e.preventDefault()
    e.stopPropagation()

    if @model.isValid()
      if @model.get('card_verified?') || @model.get('card_number') == ''
        $(@el)[0].submit()
      else
        @verify()

  verifyCard: (e)->
    e.preventDefault()
    e.stopPropagation()
    @verify()

  verify: ->
    @model.unset('errors')
    expiration_date = @model.get('card_expiration').split('/')
    card =
      number: @model.get('card_number')
      cvc: @model.get('card_cvc')
      expMonth: expiration_date[0]
      expYear: "20#{expiration_date[1]}"
    Stripe.createToken(card, @handleStripeResponse)

  changeCardDetails: (e)->
    e.preventDefault()
    e.stopPropagation()
    @previousCardInfo = {}
    _.each @cardRelatedFields, (field)=>
      field = $(field)
      name = field.attr('name').match(new RegExp(@paramRoot + "\\[([^\\]]+)\\]"))[1]
      @model.set name, ''
      @previousCardInfo[name] = field.val()
      field.val('')

    @model.set('card_verified?', false)
    $(e.currentTarget).after(@make('a', href: '#', class: 'cancel-card-change_', 'Cancel'))

  cancelCardChange: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.set('card_verified?', true)
    _.each @previousCardInfo, (value, name)=>
      @$("##{@paramRoot}_#{name}").val value

    $(e.currentTarget).remove()

  handleStripeResponse: (status, response) =>
    if 200 == status
      @model.set('card_verified?', true)
      @$('#profile_stripe_card_token').val(response.id)
      $(@el)[0].submit()
    else
      field = switch response.error.param
        when 'exp_year', 'exp_month' then 'card_expiration'
        when 'cvc' then 'card_cvc'
        when 'number' then 'card_number'
        else 'card_type'
      errors = {}
      errors[field] = [response.error.message]
      @model.set('errors', errors)

    console.log status
    console.log response

  render: ->
    @model.unset('errors')
    $(@el).backboneLink(@model, paramRoot: @paramRoot)
    if @model.get('card_verified?')
      @cardRelatedFields.addClass('uneditable-input')
      @$('.change-card_').show()
      @$('.cancel-card-change_').remove()
    else
      @cardRelatedFields.removeClass('uneditable-input')
      @$('.change-card_').hide()
    return this
