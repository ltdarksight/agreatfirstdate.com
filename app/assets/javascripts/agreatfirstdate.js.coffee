window.Agreatfirstdate =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  current_profile: null
  initAccessRoutes: ->
    Agreatfirstdate.deniedRoute = new Agreatfirstdate.Routers.AccessRouter()

  initialize: ->
    @.initAccessRoutes()

    $.ajaxSetup
      statusCode:
        403: ->
          Agreatfirstdate.deniedRoute.navigate "denied", trigger: true, replace: true

    if window.current_user_attributes
      Agreatfirstdate.currentUser = new Agreatfirstdate.Models.User(window.current_user_attributes)

    if window.current_profile_attributes
      Agreatfirstdate.currentProfile = new Agreatfirstdate.Models.Profile window.current_profile_attributes,
        collection: new Agreatfirstdate.Collections.Profiles()

      $("a[href='/searches']").on "click", (e)->
        if _.isEmpty(Agreatfirstdate.currentProfile.pillar_ids())
          e.preventDefault()
          e.stopPropagation()
          new Agreatfirstdate.Views.Search.NotChoosePillars()


    Backbone.history.start()



$(document).ready ->
  Agreatfirstdate.initialize()
