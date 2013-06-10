class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router

  initialize: (options) ->
    console.log "option", options
    Agreatfirstdate.current_profile = new Agreatfirstdate.Models.Profile options.profile
    @me = Agreatfirstdate.current_profile
    @userSearch = new Agreatfirstdate.Models.UserSearch options.profile

    @results = new Agreatfirstdate.Collections.SearchResults()
    @results.userSearch = @userSearch

    @oppositeSex = new Agreatfirstdate.Collections.OppositeSex()
    @oppositeSex.on 'reset', (collection)->
      @showOppositeResults(collection)
    , @
    @oppositeSex.fetch({})

    @results.fetch data: @userSearch.searchTerms()

    @results.on 'resetCollection', (collection) =>
      @showResults(collection)

    @userSearch.on "reset", @showFavoriteUsers, @userSearch.favoriteUsers
    @showFavoriteUsers(@userSearch.favoriteUsers())

    @searchForm = new Agreatfirstdate.Views.Search.Form(
      el: '.search-filter'
      userSearch: @userSearch
      results: @results
      oppositeSexResults: @oppositeSex
    )
    @result_count = new Agreatfirstdate.Views.Search.ResultsCount el: $("#results_count")
    @results.on 'reset', @updateResultsCount, @


    @index()

  updateResultsCount: (collection) ->
    @result_count.setElement("#results_count")
    @result_count.render(collection.length)

  index: ->

  showFavoriteUsers: (users) ->
    $('#favorite_users .favorite-users_').empty()

    unless _.isEmpty(users)
      unless @favorite_view
        @favorite_view = new Agreatfirstdate.Views.Search.FavoriteUsers el: $('#favorite_users .favorite-users_'), collection: users
      @favorite_view.render()


  showResults: (collection, index) ->
    resultsView = new Agreatfirstdate.Views.Search.Index
      collection: collection

    $('#results').html resultsView.render().el

    sliderView = new Agreatfirstdate.Views.Search.Slider
      el: $("#slider")
      collection: collection
      resultsView: resultsView

    resultsView.slider = sliderView.render().el

    resultsView.initCoverflow(index)

  showOppositeResults: (collection) ->
    console.log "oppo", collection
    @oppositeSexResultsView = new Agreatfirstdate.Views.Search.OppositeSexIndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#opposite_sex_results').html @oppositeSexResultsView.render().el
