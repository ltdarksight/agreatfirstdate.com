Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.IndexView extends Backbone.View
  template: JST["backbone/search/index"]
  emptyTemplate: JST["backbone/search/empty"]

  initialize: (options) ->
    @me = options.me
    super

  addAll: () =>
    if (@collection.length > 0)
      $(@el).empty()
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    view = new Agreatfirstdate.Views.Search.ResultItemView({model: item, me: @me})
    $(@el).append(view.render().el)

  empty: =>
    $(@el).html(@emptyTemplate())

  render: =>
    @addAll()
    return this
