Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Settings extends Backbone.View
  el: "#edit_profile"
  events:
    "submit" : 'processCard'

  initalize: ->

    @profile =  Agreatfirstdate.currentProfile

  processCard: (event)->
    event.preventDefault()
    event.stopPropagation()
    @$("#actions").hide();
    @$("#form-progress").text("card verification ...")
    @$("#form-progress").show()
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
    @stripeToken = new Backbone.StripeToken
      card:
        number: @$("[name='profile[card_number]']").val()
        exp_month: @$("[name='profile[card_expiration]']").val().split('/')[0]
        exp_year: @$("[name='profile[card_expiration]']").val().split('/')[1]
        cvc: @$("[name='profile[card_cvc]']").val()


    @stripeToken.on 'change:id', (model, token) =>
      @$("[name='profile[card_number]']").val(model.get('card').number)


    @stripeToken.on 'invalid', (model, error, options) =>
      @$("#actions").show()
      @$("#form-progress").hide()

    @stripeToken.save()
