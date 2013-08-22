Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.OppositeSexIndexView extends Backbone.View
  template: JST["search/opposite_sex/index"]
  emptyTemplate: JST["search/opposite_sex/empty"]

  initialize: (options) ->
    @me = options.me
    super

  addAll: () ->
    if (@collection.length > 0)
      $(@el).empty()
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    view = new Agreatfirstdate.Views.Search.OppositeSexResultItemView({model: item, me: @me})
    $(@el).append(view.render().el)

  empty: ->
    $(@el).html(@emptyTemplate())

  render: =>
    @addAll()
    @
