Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Slider extends Backbone.View
  
  initialize: (options) ->
    @setElement $('#search #slider')

  render: ->
    $(@el).slider
      min: 0,
      max: @collection.totalEntries-1,
      slide: @select
    this