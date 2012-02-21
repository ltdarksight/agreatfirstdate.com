Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.IndexView extends Backbone.View
  template: JST["backbone/search/index"]
  emptyTemplate: JST["backbone/search/empty"]

  initialize: (options) ->
    @me = options.me
    @userSearch = options.userSearch
    @userSearch = options.userSearch
    super

  addAll: () =>
    if (@collection.length > 0)
      $(@el).empty()
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    view = new Agreatfirstdate.Views.Search.ResultItemView({model: item, me: @me, userSearch: @userSearch})
    $(@el).append(view.render().el)

  empty: =>
    $(@el).html(@emptyTemplate())

  render: =>
    @addAll()
    return this
