Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Results extends Backbone.View
  el: '#results'

  initialize: ->
    _.bindAll @, 'handlePrev'
    _.bindAll @, 'handleNext'
    _.bindAll @, 'pageAdd'
    @initResultsView()
    @initSlider()


    @

  pageAdd: (models)->
    @resultsView.pageAdd(models)

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
    @start(1)

    @collection.off "pageAdd"
    @collection.on "pageAdd", @pageAdd, @

    $(".prev").on "click", @handlePrev
    $(".next").on "click", @handleNext

    @
