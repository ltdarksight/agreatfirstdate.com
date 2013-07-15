Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Settings extends Backbone.View
  el: "#settings"

  events:
    'click #cancel-account' : 'handleCancelAccount'

  initialize: ->
    @billiView = new Agreatfirstdate.Views.User.BillingInfo el: $("#edit_billing_profile")
    @profile =  Agreatfirstdate.currentProfile

  handleCancelAccount: ->
    new Agreatfirstdate.Views.User.CancelAccountView()
    false
