class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router

  initialize: (options) ->
    if Agreatfirstdate.currentProfile and _.isEmpty(Agreatfirstdate.currentProfile.pillar_ids())
      new Agreatfirstdate.Views.Search.NotChoosePillars()

    if options.profile
      Agreatfirstdate.current_profile = new Agreatfirstdate.Models.Profile options.profile
      @me = Agreatfirstdate.current_profile
      new Agreatfirstdate.Views.User.PointsView(model: @me)
    else
      @me = null

    @userSearch = new Agreatfirstdate.Models.UserSearch options.profile

    @results = new Agreatfirstdate.Collections.SearchResults()
    @results.userSearch = @userSearch

    @oppositeSex = new Agreatfirstdate.Collections.OppositeSex()
    @oppositeSex.on 'reset', (collection)->
      @showOppositeResults(collection)
    , @

    @searchForm = new Agreatfirstdate.Views.Search.Form(
      el: '.search-filter'
      userSearch: @userSearch
      results: @results
      oppositeSexResults: @oppositeSex
      me: @me
    )
    @results.searchForm = @searchForm

    if @me
      @oppositeSex.fetch
        data:
          gender: (@me and @me.oppositeSex())

      @results.fetch data: @userSearch.searchTerms()
    else
      @oppositeSex.fetch
        data:
          gender: @searchForm.oppositeSex()

      @results.fetch data: @searchForm.params()

    @results.on 'resetCollection', (collection) =>
      @showResults(collection)

    @results.on 'removeItem', (model)=>
      @rView.pageRemove(model)

    if @me
      @userSearch.on "reset", @showFavoriteUsers, @userSearch.favoriteUsers
      @me.on "resetFavorites", @reloadFavorites, @

      @favorite_view = new Agreatfirstdate.Views.Search.FavoriteUsers
        el: $('#favorite_users .favorite-users_')

      @showFavoriteUsers(@userSearch.favoriteUsers())



    @result_count = new Agreatfirstdate.Views.Search.ResultsCount el: $("#results_count")
    @results.on 'reset', @updateResultsCount, @


    @index()

  updateResultsCount: (collection) ->
    @result_count.setElement("#results_count")
    @result_count.render(collection.totalEntries)

  index: ->

  reloadFavorites: ->
    @me.fetch
      success: (model, _) =>
        users = @me.favoriteUsers()
        users.fetch
          success: (models, r)=>
            @showFavoriteUsers(models)

  showFavoriteUsers: (users) ->
    @favorite_view.setElement($('#favorite_users .favorite-users_'))
    @favorite_view.collection = users
    @favorite_view.render()

  showResults: (collection) ->
    @rView = new Agreatfirstdate.Views.Search.Results
      collection: collection
      el: $('#results')
    @rView.render()

  showOppositeResults: (collection) ->
    @oppositeSexResultsView = new Agreatfirstdate.Views.Search.OppositeSexIndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#opposite_sex_results').html @oppositeSexResultsView.render().el
