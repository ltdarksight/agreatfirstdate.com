class Agreatfirstdate.Routers.SearchRouter extends Backbone.Router
  initialize: (options) ->
    @me = new Agreatfirstdate.Models.User(options.user)
    @results = new Agreatfirstdate.Collections.SearchResultsCollection()
    @results.on 'reset', @showResults, this
    @index()

  routes:
    "/index": "index"

  index: ->
    @view = new Agreatfirstdate.Views.Search.FormView(user: @me, results: @results)
    @view.render()

  showResults: (collection) ->
    @view = new Agreatfirstdate.Views.Search.IndexView(collection: collection)
    $('#search #results').html @view.render().el