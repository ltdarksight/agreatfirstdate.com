Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Settings extends Backbone.View
  el: "#edit_profile"
  events:
    "submit" : 'processCard'

  initialize: ->
    _.bindAll @, "processCard"
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @stripeToken = new Backbone.StripeToken
      card:
        number: @$("[name='profile[card_number]']").val()
        exp_month: @$("[name='profile[card_expiration]']").val().split('/')[0]
        exp_year: @$("[name='profile[card_expiration]']").val().split('/')[1]
        cvc: @$("[name='profile[card_cvc]']").val()
    @valid_card = false
    @profile =  Agreatfirstdate.currentProfile


  processCard: (event)->

    @stripeToken.set "card",
      number: @$("[name='profile[card_number]']").val()
      exp_month: @$("[name='profile[card_expiration]']").val().split('/')[0]
      exp_year: @$("[name='profile[card_expiration]']").val().split('/')[1]
      cvc: @$("[name='profile[card_cvc]']").val()
    console.log "submit"
    if @stripeToken.hasChanged() and !@valid_card
      console.log "submit", "changed"
      event.preventDefault()
      event.stopPropagation()
      @$("#actions").hide();
      @$("#form-progress").text("card verification ...")
      @$("#form-progress").show()

      @stripeToken.on 'change:id', (model, token) =>
        @.$el.append("<input type='hidden' name='profile[stripe_card_token]' value='"+token+"'/>")
        @$("[name='profile[card_number]']").val(model.get('card').number)
        console.log "success"
        @valid_card = true
        @.$el.submit()


      @stripeToken.on 'invalid', (model, error, options) =>
        @$("#actions").show()
        @$("#form-progress").hide()

      @stripeToken.save()

    else
      true
