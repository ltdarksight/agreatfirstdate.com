class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router
  initialize: (options) ->
    @me = new Agreatfirstdate.Models.User options.user
    @userSearch = new Agreatfirstdate.Models.UserSearch options.user
    @showFavoriteUsers()
    @me.favoriteUsers.on 'reset', @showFavoriteUsers, this

    @results = new Agreatfirstdate.Collections.SearchResultsCollection()
    @results.on 'reset', (collection)->
      @showResults(collection)
      @updateCount(collection)
    , this
    @index()

  routes:
    "/index": "index"

  index: ->
    @view = new Agreatfirstdate.Views.Search.FormView(userSearch: @userSearch, me: @me, results: @results)
    @view.render()
    @view.find()

  showFavoriteUsers: ->
    @favoritesView = new Agreatfirstdate.Views.Search.FavoriteUsersView(me: @me, userSearch: @userSearch)
    $('#favorite_users .favorite-users_').html(@favoritesView.render().el)

  showResults: (collection) ->
    @view = new Agreatfirstdate.Views.Search.IndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#search #results').html @view.render().el

  updateCount: (collection) ->
    @view = new Agreatfirstdate.Views.Search.CountView(collection: collection)
    @view.render()