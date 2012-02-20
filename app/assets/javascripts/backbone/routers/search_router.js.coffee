class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router
  initialize: (options) ->
    @me = new Agreatfirstdate.Models.User options.user
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
    @view = new Agreatfirstdate.Views.Search.FormView(user: @me, results: @results)
    @view.render()
    @view.find()

  showFavoriteUsers: ->
    @favoritesView = new Agreatfirstdate.Views.Search.FavoriteUsersView(me: @me)
    $('#favorite_users .favorite-users_').html(@favoritesView.render().el)

  showResults: (collection) ->
    @view = new Agreatfirstdate.Views.Search.IndexView(collection: collection, me: @me)
    $('#search #results').html @view.render().el

  updateCount: (collection) ->
    @view = new Agreatfirstdate.Views.Search.CountView(collection: collection)
    @view.render()