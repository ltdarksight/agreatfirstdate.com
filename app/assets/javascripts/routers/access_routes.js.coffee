class Agreatfirstdate.Routers.AccessRouter extends Backbone.Router
  routes:
    "denied" : "denied"

  initialize: ->

  denied: ->
    notify = new Agreatfirstdate.Views.Application.Notification
      head: "Error"
      body: "<p style='color:red;'>You are not authorized to access this action.</p>"
      view: @

    @
