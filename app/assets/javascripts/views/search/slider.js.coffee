Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Slider extends Backbone.View

  el: $('#slider')

  initialize: ->
    @resultsView = @options.resultsView

  select: (event, ui) =>
    @resultsView.select(ui.value)

  setValue: (value)->
    @.$el.slider('option', 'value', value)

  render: ->
    $(@el).slider
      min: 0
      max: @collection.totalEntries-1
      slide: @select

    @
