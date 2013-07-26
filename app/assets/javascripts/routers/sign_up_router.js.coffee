class Agreatfirstdate.Routers.SignUpRouter extends Backbone.Router
  routes:
    'successful-sign-up': 'success'

  success: ->
    notification = new Agreatfirstdate.Views.Application.Notification
      header: 'Success'
      body: "Sweet!  Thanks for signing up!  We've sent you an e-mail to confirm you are a real person. Please click the link in the e-mail to start finding your great dates!"
      view: @
      allowSave: true
      saveText: 'OK'
      saveHref: '/'
      allowClose: false

    @
