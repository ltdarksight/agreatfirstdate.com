Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ConnectView extends Backbone.View
  template: JST["facebook/connect"]
  el: $("#popup-facebook-connect")

  initialize: ->

    if _.has(@.options, 'afterLogin')
      window.afterLogin = @.options.afterLogin
    else
      window.afterLogin = ->


    if _.has(@.options, 'afterFailLogin')
      window.afterFailLogin = @.options.afterFailLogin
    else
      window.afterFailLogin = ->



    @popupCenter("/users/auth/facebook?popup_photo=true", 300, 200, "authPopup")
    @

  popupCenter: (url, width, height, name) ->
    @left = (screen.width/2)-(width/2)
    @top = (screen.height/2)-(height/2);

    @win = window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+@left+",top="+@top)

  show: ->
    @render()
    @.$el.modal('show')

  render: ->
    @.$el.html(@template({ url: "/users/auth/facebook" }))

    @
