Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Photo extends Backbone.View
  className: 'profile-photo'
  template: JST["users/photos/show"]

  initialize: ->
  #   @getCurrent()
  #   @model.avatars.on 'reset', (collection)=>
  #     @getCurrent()
  #     @render()

  # getCurrent: ->
  #   @avatar = @model.avatars.current()
  #   if @avatar
  #     @avatar.on 'crop', =>
  #       @render()

  render: ->
    $(@el).html @template(avatar: @model.avatars.current())
    # if @model.avatars.length>0
    #   items = @$(".carousel-inner .item")
    #   items.eq(Math.floor(Math.random()*items.length)).addClass "active"
    #   @$(".carousel").carousel interval: 30000
    this