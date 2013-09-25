class Agreatfirstdate.Views.InstagramConnectView extends Backbone.View
  template: JST["instagram/connect"]
  el: $("#popup-instagram-connect")
  initialize: ->
    window.location.href = "/users/auth/instagram"

  show: ->
    @render()
    @.$el.modal('show')

  render: ->
    @.$el.html(@template({ url: "/users/auth/instagram" }))

    @
