Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.IndexView extends Backbone.View
  template: JST["backbone/search/index"]
  emptyTemplate: JST["backbone/search/empty"]
  showMoreTemplate: JST["backbone/search/show_more_link"]

  initialize: (options) ->
    @me = options.me
    @userSearch = options.userSearch
    super

  itemViews: []

  addAll: () =>
    if (@collection.length > 0)
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    view = @itemViews[item.position]
    view.model = item
    view.renderPreview()

  empty: =>
    $(@el).html(@emptyTemplate())

  skipTo: (event, sky)=>
    page = Math.ceil((sky.value+1)/@collection.itemsPerPage)
    @collection.loadPage(page - 1)
    @collection.loadPage(page + 1)
    $(@slider).slider('option', 'value', sky.value)

    _.each @itemViews, (el, id)->
      if sky.value == id
        el.renderFull()
      else
        el.renderPreview() unless el.status == 'preview' || el.status == 'fake'
    , this

  select: (value)=>
    page = Math.ceil((value+1)/@collection.itemsPerPage)
    if @collection.pageLoaded(page)
      @coverflowCtrl.coverflow 'select', value, false
    else
      @collection.loadPage page, success: =>
        @coverflowCtrl.coverflow 'select', value, false

  render: =>
    @addAll()
    return this

  addCoverflowItems: =>
   @coverflowCtrl.coverflow('initItems') if @coverflowCtrl

  initFakes: ->
    $(@el).empty()
    @itemViews = []
    for id in [0..@collection.totalEntries-1]
      view = new Agreatfirstdate.Views.Search.ResultItemView({me: @me})
      $(@el).append(view.renderFake().el)
      @itemViews[id] = view

  initCoverflow: =>
    if @collection.length
      @defaultItem = _.min([2, @collection.length-1])
      @coverflowCtrl = $('#results > div')
      @itemViews[@defaultItem].renderFull()
      $(@slider).slider('option', 'value', @defaultItem)

      @coverflowCtrl.coverflow
        item: @defaultItem,
        duration: 1200,
        select: @skipTo


