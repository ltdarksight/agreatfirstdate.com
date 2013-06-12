Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Results extends Backbone.View
  el: '#results'
  events:
    "click .prev" : 'handlePrev'
    "click .next" : 'handleNext'


  initialize: ->
    @initResultsView()
    @initSlider()

    @

  initResultsView: ->
    @resultsView = new Agreatfirstdate.Views.Search.Index
      collection: @collection
      resultsContainer: @

  initSlider: ->
    @sliderView = new Agreatfirstdate.Views.Search.Slider
      el: $("#slider")
      collection: @collection
      resultsView: @resultsView
      resultsContainer: @

    @sliderView.render()

    @resultsView.slider = @sliderView

  handlePrev: (event) ->
    @resultsView.shift event, -1

  handleNext: (event) ->
    @resultsView.shift event, 1,

  start: (index) ->
    @resultsView.initCoverflow(index)

  render: ->
    @.$el.html @resultsView.render().el

    @
