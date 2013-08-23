class Agreatfirstdate.Routers.UserSettingRouter extends Backbone.Router
  routes:
    "billing" : 'expandBillingSection'

  initialize: (options) ->
    @profile =  Agreatfirstdate.currentProfile

  expandBillingSection: (event) ->
    $('html, body').animate({
        scrollTop: $("h3.billing").offset().top - 100
    }, 500);
    $('h3.billing').removeClass("collapsed").addClass("expanded")
    $('h3.billing').next().show()
