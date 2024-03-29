Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.BillingInfo extends Backbone.View
  el: "#edit_billing_profile"
  events:
    'change #profile_zip': 'populateGeodata'
    'click #join-now' : 'handleSubmit'
    'change #profile_discount_code' : 'changeDiscount'
    'blur #profile_discount_code' : 'changeDiscount'
    'click #delete-credit-card' : 'handleDeleteCard'
    'click #js-edit-credit-card' : 'handleEditCard'

  initialize: ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @billing = new Agreatfirstdate.Models.UserBilling
    @profile =  Agreatfirstdate.currentProfile
    @geo = new Agreatfirstdate.Models.GeoLookup

  handleEditCard: (event)->
    event.preventDefault()
    $("#manage-card-actions").hide()
    $('input, select', "#card-info").val("")
    @$(".help-inline.error").remove()
    @$(".error").removeClass('error')
    $("#card-info").show()

  handleDeleteCard: ->
    @confirm = new Agreatfirstdate.Views.Application.Confirm
      header: 'Delete credit card'
      body: 'Are you sure?'
      view: @
      success: =>
        @billing.destroy
          success: (model, response)=>
            @confirm.hide()
            window.location.reload()
    false

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
      }

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
    @$(".error").removeClass('error')
    @$("[name='profile["+error.field+"]']").parents(".control-group:first").addClass("error")
    @$("[name='profile["+error.field+"]']").parents(".controls:first").append($("<span />", { class: 'help-inline error', text: error.message}))
    @$("#join-now").removeClass('disabled')

  showServerErrors: (model, errors) ->
    @$(".help-inline.error").remove()
    @$(".error").removeClass('error')
    @$("#join-now").removeClass('disabled')
    _.each errors, (messages, field)->
      @$("[name='profile["+field+"]']").parents(".control-group:first").addClass("error")
      @$("[name='profile["+field+"]']").parents(".controls:first").append($("<span />", { class: 'help-inline error', text: messages.join(', ')}))

  handleSubmit: (event)->
    @spinner = new Agreatfirstdate.Views.Application.Spinner()
    @spinner.show()

    event.preventDefault()
    event.stopPropagation()
    return false if @$("#join-now").hasClass('disabled')

    # lock Join Now
    @$("#join-now").addClass('disabled')

    attrs = Backbone.Syphon.serialize(@.$el[0])["profile"]

    unless _.isEmpty($(@el).find('#card_number').val())
      @processWithCard(attrs)
    else
      billing_attrs = Backbone.Syphon.serialize(@.$el[0])
      @saveBillingInfo(billing_attrs)

    false

  # save billing info on the server
  saveBillingInfo: (data)->

    result = @billing.save data,
      success: (model, response) =>
        # saved billing info
        @spinner.hide()
        @$("#join-now").removeClass('disabled')

        unless _.isEmpty model.get('stripe_customer_token')
          @$("#join-now").text('Update Billing Account')
        @$("#billing-update-flash").text("Your billing info has been renewed successfully.")

        if @$("#card-info").length > 0
          unless _.isEmpty model.get('stripe_customer_token')
            card_type = response.card_type.toLowerCase().replace(/\W/, '-')
            $('#js-card-type').attr('src', $('#js-card-type').data(card_type))
            $maskedCardInfo = $("#masked-card-info")
            $maskedCardInfo.find("p.card-number").html("**** **** **** " + response.card_last4)
            $maskedCardInfo.find("p.ending-in").html("Ending in: #{ response.card_exp_month }/#{ response.card_exp_year }")
            $("#card-info").hide()
            $("#manage-card-actions").show()


      error: (model, response) =>
        # error while saving billing info
        @spinner.hide()
        errors = $.parseJSON(response.responseText)
        @showServerErrors(model, errors)
        @$("#join-now").removeClass('disabled')

  # valid card data & get token from Stripe
  processWithCard: (attrs) ->
    Stripe.card.createToken
      number: $(@el).find('#card_number').val()
      cvc: $(@el).find('#card_cvc').val()
      exp_month: $(@el).find('#card_exp_month').val()
      exp_year: $(@el).find('#card_exp_year').val()
      name: attrs["billing_full_name"]
      address_line1: attrs["address1"]
      address_line2: attrs["address2"]
      address_city: attrs["city"]
      address_state: attrs["state"]
      address_zip: attrs["zip"]
      address_country: attrs["country"]
    , @stripeResponseHandler

  stripeResponseHandler: (status, response) =>
    if (response.error)
      error = response.error
      if error.type == 'card_error'
        if error.param == 'number' || error.param == 'cvc' || error.param == 'exp_month'
          $(@el).find('#card_' + error.param).parents(".control-group:first").addClass("error")
          $(@el).find('#card_' + error.param).parents(".controls:first").append($("<span />", { class: 'help-inline error', text: error.message}))

      @$("#join-now").removeClass('disabled')
    else
      token = response['id']
      billing_attrs = Backbone.Syphon.serialize(@.$el[0])
      billing_attrs.profile.stripe_card_token = response['id']
      @saveBillingInfo(billing_attrs)

    @spinner.hide()

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
      }

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
