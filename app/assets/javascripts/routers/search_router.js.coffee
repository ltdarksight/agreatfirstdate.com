class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router

  initialize: (options) ->

    @userSearch = new Agreatfirstdate.Models.UserSearch options.profile

    @results = new Agreatfirstdate.Collections.SearchResults()
    @results.userSearch = @userSearch

    @oppositeSex = new Agreatfirstdate.Collections.OppositeSex()

    @results.fetch data: @userSearch.searchTerms()

    @results.on 'resetCollection', (collection) =>
      @showResults(collection)

    @searchForm = new Agreatfirstdate.Views.Search.Form(
      el: '.search-filter'
      userSearch: @userSearch
      results: @results
      oppositeSexResults: @oppositeSex
    )

    @index()

  index: ->

  showResults: (collection, index) ->
    resultsView = new Agreatfirstdate.Views.Search.Index(
      collection: collection
    )

    $('#results').html resultsView.render().el

    sliderView = new Agreatfirstdate.Views.Search.Slider(
      collection: @results
      resultsView: resultsView
    )

    resultsView.slider = sliderView.render().el

    resultsView.initCoverflow(index)

    # @resultsView.remove() if @resultsView
    # @resultsView = new Agreatfirstdate.Views.Search.IndexView(collection: collection, me: @me, userSearch: @userSearch)
    # @resultsView.initFakes()
    # $('#search #results').html @resultsView.render().el
    #
    # @sliderView = new Agreatfirstdate.Views.Search.SliderView(collection: @results, resultsView: @resultsView)
    # @resultsView.slider = @sliderView.render().el
    # $(@resultsView.slider).find('a').toggle(collection.totalEntries > 1)
    # @resultsView.initCoverflow(index)
