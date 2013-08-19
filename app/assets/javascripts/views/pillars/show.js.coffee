Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Show extends Backbone.View
  template: JST["pillars/show"]

  initialize: (options) ->
    @model.photos.on 'reset', (collection)=>
      @render()
    @model.on "change", @render, @

  showCarousel: ->
    if @model.photos.length>0
      item = Math.floor(Math.random()*@model.photos.length)


      @$('.carousel-pillar_photos .carousel').jcarousel().jcarouselAutoscroll(interval: 10000)
    @

  render: ->
    $(@el).html(@template(pillar: @model, item: Math.floor(Math.random()*@model.photos.length)))
    @showCarousel()
    @
