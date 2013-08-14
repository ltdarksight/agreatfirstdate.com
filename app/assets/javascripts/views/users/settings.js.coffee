Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Settings extends Backbone.View
  el: "#settings"

  events:
    'click #cancel-account' : 'handleCancelAccount'
    'click h3.collapsed' : 'handleExpandSection'
    'click h3.expanded' : 'handleCollapseSection'

  initialize: ->
    @billiView = new Agreatfirstdate.Views.User.BillingInfo el: $("#edit_billing_profile")
    @profile =  Agreatfirstdate.currentProfile

  handleExpandSection: (event) ->
    _el = $(event.target)
    $(_el).removeClass("collapsed").addClass("expanded")
    $(_el).next().show()

  handleCollapseSection: (event) ->
    _el = $(event.target)
    $(_el).removeClass("expanded").addClass("collapsed")
    $(_el).next().hide()

  handleCancelAccount: ->
    new Agreatfirstdate.Views.User.CancelAccountView()
    false
