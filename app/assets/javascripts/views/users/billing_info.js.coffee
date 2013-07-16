Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.BillingInfo extends Backbone.View
  el: "#edit_billing_profile"
  events:
    'change #profile_zip': 'populateGeodata'
    'submit' : 'handleSubmit'
    'change #profile_discount_code' : 'changeDiscount'

  initialize: ->
    _.bindAll @, "processCard"
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @stripeToken = new Backbone.StripeToken
    @stripeToken.on "invalid", @cardErrors, @
    @stripeToken.on 'change:id', (model, token) =>

    @stripeToken.on "error", (model, response, options) =>

    @billing = new Agreatfirstdate.Models.UserBilling
    @profile =  Agreatfirstdate.currentProfile
    @geo = new Agreatfirstdate.Models.GeoLookup

  changeDiscount: (event) ->
    discount = new Agreatfirstdate.Models.Discount
    discount.fetch
      data:
        code: @$("#profile_discount_code").val()
      ,
      success: (model, response)=>
        @$("#total-amount").text(accounting.formatMoney(model.discount(20.00)))

  exp_month: (date)->
    if date
      date.split('/')[0]
    else
      ""

  exp_year: (date)->
    if date
      date.split('/')[1]
    else
      ""

  cardErrors: (model, error) ->
    @$(".help-inline.error").remove()
    @$(".error").removeClass('error');
    @$("[name='profile["+error.field+"]']").parents(".control-group:first").addClass("error")
    @$("[name='profile["+error.field+"]']").parents(".controls:first").append($("<span />", { class: 'help-inline error', text: error.message}))

  handleSubmit: (event)->
    event.preventDefault()
    event.stopPropagation()
    # lock Join Now
    @$("#join-now").addClass("disabled")

    attrs = Backbone.Syphon.serialize(@.$el[0])["profile"]
    @stripeToken.set "card",
      cvc: attrs["card_cvc"]
      number: attrs["card_number"]
      exp_month:  @exp_month(attrs["card_expiration"])
      exp_year: @exp_year(attrs["card_expiration"])
      name: attrs["billing_full_name"]
      address_line1: attrs["address1"]
      address_line2: attrs["address2"]
      address_city: attrs["city"]
      address_state: attrs["state"]
      address_zip: attrs["state"]
      address_country: attrs["country"]

    @stripeToken.save
      success: (model, response)=>
        billing_attrs = Backbone.Syphon.serialize(@.$el[0])
        billing_attrs.profile.stripe_card_token = model.id
        @billing.save billing_attrs

    false

  populateGeodata: ->
    opts = {
      lines: 5,
      length: 1,
      width: 3,
      radius: 3,
      corners: 1,
      rotate: 13,
      direction: 1,
      color: '#000',
      speed: 0.6,
      trail: 100,
      shadow: false,
      hwaccel: false,
      className: 'spinner',
      zIndex: 2e9,
      top: '4',
      left: '268'
      };

    @$(".zip-spin").spin(opts)

    data = {data: {zip: @$('#profile_zip').val() }}
    @geo.fetch
      data:
        zip: @$('#profile_zip').val()
      success: (model, response) =>
        @$('#profile_city').val model.get('city')
        @$('#profile_state').val model.get('state')

      complete: =>
        @$(".zip-spin").spin(false)



  processCard: (event)->

    @stripeToken.set "card",
      number: @$("[name='profile[card_number]']").val()
      exp_month: @$("[name='profile[card_expiration]']").val().split('/')[0]
      exp_year: @$("[name='profile[card_expiration]']").val().split('/')[1]
      cvc: @$("[name='profile[card_cvc]']").val()
    if @stripeToken.hasChanged() and !@valid_card
      event.preventDefault()
      event.stopPropagation()
      @$("#actions").hide();
      @$("#form-progress").text("card verification ...")
      @$("#form-progress").show()

      @stripeToken.on 'change:id', (model, token) =>
        @.$el.append("<input type='hidden' name='profile[stripe_card_token]' value='"+token+"'/>")
        @$("[name='profile[card_number]']").val(model.get('card').number)
        @valid_card = true
        @.$el.submit()


      @stripeToken.on 'invalid', (model, error, options) =>
        @$("#actions").show()
        @$("#form-progress").hide()

      @stripeToken.save()

    else
      true
