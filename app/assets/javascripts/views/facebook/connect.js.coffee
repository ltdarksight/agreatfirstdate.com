Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ConnectView extends Backbone.View
  template: JST["facebook/connect"]
  el: $("#popup-facebook-connect")
  initialize: ->
    @show()

  show: ->
    @render()
    @.$el.modal('show')

  render: ->
    @.$el.html(@template({ url: "/users/auth/facebook" }))

    @
