Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.BillingInfo extends Backbone.View
  el: "#edit_billing_profile"
  events:
    'change #profile_zip': 'populateGeodata'
    'click #join-now' : 'handleSubmit'
    'change #profile_discount_code' : 'changeDiscount'
    'blur #profile_discount_code' : 'changeDiscount'

  initialize: ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @stripeToken = new Backbone.StripeToken
    @stripeToken.on "invalid", @cardErrors, @
    @stripeToken.on 'change:id', (model, token) =>

    @stripeToken.on "error", (model, response, options) =>

    @billing = new Agreatfirstdate.Models.UserBilling
    @profile =  Agreatfirstdate.currentProfile
    @geo = new Agreatfirstdate.Models.GeoLookup

  changeDiscount: (event) ->
    opts = {
      lines: 5,
      length: 1,
      width: 3,
      radius: 3,
      corners: 1,
      rotate: 13,
      direction: 1,
      color: 'green',
      speed: 0.6,
      trail: 100,
      shadow: false,
      hwaccel: false,
      className: 'spinner',
      zIndex: 2e9,
      top: '-38',
      left: '200'
      };

    @$("#discount-block .help-block").spin(opts)

    discount = new Agreatfirstdate.Models.Discount
    discount.fetch
      data:
        code: @$("#profile_discount_code").val()
      ,
      success: (model, response)=>
        @$("#total-amount").text(accounting.formatMoney(model.discount(20.00)))
      complete: =>
        @$("#discount-block .help-block").spin(false)


  cardErrors: (model, error) ->
    @$(".help-inline.error").remove()
    @$(".error").removeClass('error');
    @$("[name='profile["+error.field+"]']").parents(".control-group:first").addClass("error")
    @$("[name='profile["+error.field+"]']").parents(".controls:first").append($("<span />", { class: 'help-inline error', text: error.message}))
    @$("#join-now").removeClass('disabled')

  showServerErrors: (model, errors) ->
    @$(".help-inline.error").remove()
    @$(".error").removeClass('error');
    @$("#join-now").removeClass('disabled')
    _.each errors, (messages, field)->
      @$("[name='profile["+field+"]']").parents(".control-group:first").addClass("error")
      @$("[name='profile["+field+"]']").parents(".controls:first").append($("<span />", { class: 'help-inline error', text: messages.join(', ')}))

  handleSubmit: (event)->
    event.preventDefault()
    event.stopPropagation()
    return false if @$("#join-now").hasClass('disabled')

    # lock Join Now
    @$("#join-now").addClass('disabled')

    attrs = Backbone.Syphon.serialize(@.$el[0])["profile"]
    if _.has(attrs, "card_number")
      @processWithCard(attrs)
    else
      billing_attrs = Backbone.Syphon.serialize(@.$el[0])
      @saveBillingInfo(billing_attrs)

    false

  # save billing info on the server
  saveBillingInfo: (data)->
    @billing.save data,
      success: (model, response) =>
        # saved billing info
        @$("#join-now").removeClass('disabled')
        if @$("#card-info").length > 0
          $(@$("#card-info").parents("span:first")).text("Thank you for join us.")
        else
          @$("#billing-update-flash").text("Your billing info has been renewed successfully.")
          _.delay(
            => @$("#billing-update-flash").empty()
            ,
            1500
          )
      error: (model, response) =>
        # error on the save billing info
        errors = $.parseJSON(response.responseText)
        @showServerErrors(model, errors)
        @$("#join-now").removeClass('disabled')

  # valid card data & get token from Stripe
  processWithCard: (attrs)->
    @stripeToken.set "card",
      cvc: attrs["card_cvc"]
      number: attrs["card_number"]
      exp_month:  attrs["card_exp_month"]
      exp_year: attrs["card_exp_year"]
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
        @saveBillingInfo(billing_attrs)

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
