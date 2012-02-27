class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router
  initialize: (options) ->
    unless @isGuest = options.guest
      @me = new Agreatfirstdate.Models.User options.user
      @me.profileCompleted = options.profile_completed
      if @me.profileCompleted
        @showFavoriteUsers()
        @me.favoriteUsers.on 'reset', @showFavoriteUsers, this

    @userSearch = new Agreatfirstdate.Models.UserSearch options.user

    @oppositeSex = new Agreatfirstdate.Collections.OppositeSexCollection()
    @oppositeSex.on 'reset', (collection)->
      @showOppositeResults(collection)
    , this
    @oppositeSex.reset options.opposite_sex

    @results = new Agreatfirstdate.Collections.SearchResultsCollection()
    @results.userSearch = @userSearch

    @results.on 'resetCollection', (collection)=>
      @showResults(collection)

    @results.on 'pageAdd', (models)=>
      if @resultsView
        _.each models, (model)=> @resultsView.addOne model
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
    @resultsView.initFakes()
    $('#search #results').html @resultsView.render().el

    @sliderView = new Agreatfirstdate.Views.Search.SliderView(collection: @results, resultsView: @resultsView)
    @resultsView.slider = @sliderView.render().el
    $(@resultsView.slider).toggle(collection.totalEntries > 1)
    @resultsView.initCoverflow()

  showOppositeResults: (collection) ->
    @oppositeSexResultsView = new Agreatfirstdate.Views.Search.OppositeSexIndexView(collection: collection, me: @me, userSearch: @userSearch)
    $('#search #opposite_sex_results').html @oppositeSexResultsView.render().el
