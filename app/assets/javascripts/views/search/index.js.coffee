Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Index extends Backbone.View

  template: JST["search/index"]
  emptyTemplate: JST["search/empty"]
  className: 'coverflow'
  itemViews: []

  initialize: (options) ->
    i = 0
    $('.alert').remove()
    $('#results').empty('')

    @collection.on "pageAdd", @pageAdd, @

    @collection.each (model) ->
      view = new Agreatfirstdate.Views.Search.ResultItem(
        collection: @collection
        model: model
      )

      $(@el).append(view.renderFake().el)
      @itemViews[i++] = view
    , @

  pageAdd: (models)->
    _.each models, (model)=>
      @addOne model
    $('#results > div').data("coverflow").reload()

  empty: ->
    $('.alert').remove()
    $('#results').before(@emptyTemplate())
    $(@el).html('')

  addAll: ->
    if (@collection.length > 0)
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) =>
    unless view = @itemViews[item.position]
      i = @itemViews.length
      view = new Agreatfirstdate.Views.Search.ResultItem
        collection: @collection
        model: item
      $(@el).append(view.renderFake().el)
      @itemViews[i++] = view

    view.model = item
    view.renderPreview()

  render: ->
    @addAll()
    this

  select: (value) =>
    page = Math.ceil((value+1) / @collection.itemsPerPage)
    if @collection.pageLoaded(page)
      @coverflowCtrl.coverflow 'select', value, false
    else
      @collection.loadPage page,
        success: =>
          @coverflowCtrl.coverflow 'select', value, false

  shift: (e, value) =>
    e.preventDefault()
    e.stopPropagation()

    position = @coverflowCtrl.coverflow('getCurrent') + value
    position = 0 if position < 0
    position = @collection.totalEntries - 1 if position >= @collection.totalEntries
    @coverflowCtrl.coverflow 'select', position, false

  skipTo: (event, sky)=>
    page = Math.ceil((sky.value+1) / @collection.itemsPerPage)
    @collection.loadPage(page - 1)
    @collection.loadPage(page + 1)
    $(@slider).slider('option', 'value', sky.value)

    _.each @itemViews, (el, id)->
      if sky.value == id
        el.renderFull()
      else
        el.renderPreview() unless el.status == 'preview' || el.status == 'fake'
    , this

  initCoverflow: (index) =>
    if @collection.length
      index = 2 unless index?
      @defaultItem = _.min([index, @collection.length-1])
      @coverflowCtrl = $('#results > div')
      @slider =$('#slider')
      @itemViews[@defaultItem].renderFull()
      $(@slider).slider('option', 'value', @defaultItem)

      @coverflowCtrl.coverflow
        item: @defaultItem,
        duration: 1200,
        select: @skipTo

      left_btn = $('<div class="prev">prev</div>').on "click", (event)=>
        @shift(event, -1)
      right_btn = $('<div class="next">next</div>').on "click", (event)=>
        @shift(event, 1)
      $('#results').append left_btn, right_btn
