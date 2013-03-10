Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Show extends Backbone.View
  template: JST["pillars/show"]

  initialize: (options) ->
    @model.photos.on 'reset', (collection)=>
      @render()
  
  render: ->
    $(@el).html(@template(pillar: @model))
    
    @$('.carousel-pillar_photos').jcarousel
    this