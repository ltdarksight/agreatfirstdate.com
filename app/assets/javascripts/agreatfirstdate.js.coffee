window.Agreatfirstdate =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  current_profile: null
  initialize: ->
    if window.current_user_attributes
      Agreatfirstdate.currentUser = new Agreatfirstdate.Models.User(window.current_user_attributes)

    if window.current_profile_attributes
      Agreatfirstdate.currentProfile = new Agreatfirstdate.Models.Profile(window.current_profile_attributes)


    Backbone.history.start()



$(document).ready ->
  Agreatfirstdate.initialize()
