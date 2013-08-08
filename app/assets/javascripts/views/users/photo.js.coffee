Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Photo extends Backbone.View
  template: JST["users/photos/show"]
  el: $('#pillarAboutMePhoto')

  initialize: ->
    @model.on "change", @render, @
  #   @getCurrent()
  #   @model.avatars.on 'reset', (collection)=>
  #     @getCurrent()
  #     @render()

  # getCurrent: ->
  #   @avatar = @model.avatars.current()
  #   if @avatar
  #     @avatar.on 'crop', =>
  #       @render()

  showCarousel: ->


    if @model.avatars.length>0
      if $('.carousel-avatars .carousel').data('jcarousel')
        $('.carousel-avatars .carousel').jcarousel('reload').jcarouselAutoscroll(
          interval: 10000
        )
      else
        item = Math.floor(Math.random()*@model.avatars.length)

        $('.carousel-avatars .carousel').on("createend.jcarousel", =>
          $('.carousel-avatars .carousel ul').css({left: (item * -200) + 'px'})
        ).jcarousel(
          wrap: 'circular'
        ).jcarouselAutoscroll(
          interval: 10000
        )
    @

  render: ->
    @.$el.html @template(model: @model)
    @showCarousel()
    @
