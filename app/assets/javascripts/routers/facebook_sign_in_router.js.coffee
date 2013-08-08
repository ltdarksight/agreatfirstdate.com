class Agreatfirstdate.Routers.FacebookSignInRouter extends Backbone.Router
  routes:
    'unlinked-facebook': 'unlinked'

  unlinked: ->
    notification = new Agreatfirstdate.Views.Application.Notification
      header: 'Alert'
      body: "Oops! Your Facebook account is linked to another profile. Please sign out of Facebook and try again."
      view: @
      allowSave: false
      allowClose: true
      typeClose: 'button'
    @
