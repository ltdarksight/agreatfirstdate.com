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
    #  card:
    #    number: @$("[name='profile[card_number]']").val()
    #    exp_month: @$("[name='profile[card_expiration]']").val().split('/')[0]
    #    exp_year: @$("[name='profile[card_expiration]']").val().split('/')[1]
    #    cvc: @$("[name='profile[card_cvc]']").val()
    @valid_card = false
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

  handleSubmit: (event)->
    console.log "submit"
    event.preventDefault()
    event.stopPropagation()
    # lock Join Now
    @$("button").addClass("disabled")

    # Backbone.Syphon.serialize(@$('form')[0], include: @fields)

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
