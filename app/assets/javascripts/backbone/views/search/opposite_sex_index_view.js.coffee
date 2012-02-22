Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.OppositeSexIndexView extends Backbone.View
  template: JST["backbone/search/opposite_sex/index"]
  emptyTemplate: JST["backbone/search/opposite_sex/empty"]
  showMoreTemplate: JST["backbone/search/opposite_sex/show_more_link"]

  initialize: (options) ->
    @me = options.me
    @userSearch = options.userSearch
    super

  events:
    "click .show-more_": "showMore"

  showMore: (e)->
    e.preventDefault()
    e.stopPropagation()
    @collection.fetch data: $.extend({gender: @userSearch.get('looking_for')}, page: @collection.page + 1), add: true

  addAll: () ->
    if (@collection.length > 0)
      $(@el).empty()
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    @$('.show-more_').remove()
    view = new Agreatfirstdate.Views.Search.OppositeSexResultItemView({model: item, me: @me})
    $(@el).append(view.render().el)
    if @collection.totalEntries > @collection.length
      $(@el).append(@showMoreTemplate())

  empty: ->
    $(@el).html(@emptyTemplate())

  render: =>
    @addAll()
    return this
