Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Show extends Backbone.View
  template: JST["pillars/show"]

  initialize: (options) ->
    # @model.photos.on 'reset', (collection)=>
    #   @render()
  
  render: ->
    $(@el).html(@template(pillar: @model))
    if @model.photos.length > 0
      items = @$(".carousel-inner .item")
      items.eq(Math.floor(Math.random()*items.length)).addClass "active"
      @$(".carousel").carousel interval: 30000
      
    this