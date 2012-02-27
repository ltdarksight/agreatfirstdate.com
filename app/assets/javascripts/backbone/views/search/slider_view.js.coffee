Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.SliderView extends Backbone.View
  initialize: (options)->
    super
    @resultsView = options.resultsView
    @setElement $('#search #slider')
    _.bindAll(this, 'select')

  select: (event, ui)->
    @resultsView.select(ui.value)

  render: ->
    $(@el).slider
      min: 0,
      max: @collection.totalEntries-1,
      slide: @select
    return this
