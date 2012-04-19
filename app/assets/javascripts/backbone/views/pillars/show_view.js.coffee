Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ShowView extends Backbone.View
  template: JST["backbone/pillars/show"]

  initialize: (options) ->
    super(options)

    @model.photos.on 'reset', (collection)=>
      @render()

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    if @model.photos.length>0
      items = @$(".carousel-inner .item")
      items.eq(Math.floor(Math.random()*items.length)).addClass "active"
      @$(".carousel").carousel interval: 30000

    return this
