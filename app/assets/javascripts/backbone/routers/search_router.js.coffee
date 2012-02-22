class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router
  initialize: (options) ->
    @me = new Agreatfirstdate.Models.User options.user
    @userSearch = new Agreatfirstdate.Models.UserSearch options.user

    @showFavoriteUsers()
    @me.favoriteUsers.on 'reset', @showFavoriteUsers, this
    @oppositeSex = new Agreatfirstdate.Collections.OppositeSexCollection()
    @oppositeSex.on 'reset', (collection)->
      @showOppositeResults(collection)
    , this

    @oppositeSex.on 'add', (model, collection)->
      @oppositeSexResultsView.addOne model if @oppositeSexResultsView
    , this
    @oppositeSex.reset options.opposite_sex

    @results = new Agreatfirstdate.Collections.SearchResultsCollection()
    @results.on 'reset', (collection)->
      @showResults(collection)
    , this

    @results.on 'add', (model, collection)->
      @resultsView.addOne model if @resultsView
    , this
    @index()

  routes:
    "/index": "index"

  index: ->
    @indexView = new Agreatfirstdate.Views.Search.FormView(userSearch: @userSearch, me: @me, results: @results, oppositeSexResults: @oppositeSex)
    @indexView.render()
    @indexView.find()
    new Agreatfirstdate.Views.Search.CountView(collection: @results).render()

  showFavoriteUsers: ->
    @favoritesView = new Agreatfirstdate.Views.Search.FavoriteUsersView(me: @me)
    $('#favorite_users .favorite-users_').html(@favoritesView.render().el)

  showResults: (collection) ->
    @resultsView = new Agreatfirstdate.Views.Search.IndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#search #results').html @resultsView.render().el

  showOppositeResults: (collection) ->
    @oppositeSexResultsView = new Agreatfirstdate.Views.Search.OppositeSexIndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#search #opposite_sex_results').html @oppositeSexResultsView.render().el
