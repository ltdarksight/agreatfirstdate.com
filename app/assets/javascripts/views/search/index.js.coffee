Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Index extends Backbone.View

  template: JST["search/index"]
  emptyTemplate: JST["search/empty"]
  className: 'coverflow'
  itemViews: []

  initialize: (options) ->
    _.bindAll @, "addAll"
    _.bindAll @, "addOne"
    _.bindAll @, "shift"
    _.bindAll @, "pageAdd"
    _.bindAll @, "skipTo"

    i = 0
    $('.alert').remove()
    $('#results').empty('')
    @itemViews = []
    @collection.each (model) ->
      view = new Agreatfirstdate.Views.Search.ResultItem(
        collection: @collection
        model: model
      )

      $(@el).append(view.renderFake().el)
      @itemViews[i++] = view
    , @

  reloadCoverFlow: ->
    $('.coverflow').coverflow('initItems')

  pageRemove: (model) ->
    itemView = _.find @itemViews, (iView)->
      iView.model.get('id') == model.get('id')

    _itemViews = _.reject @itemViews, (iView) ->
      iView.model.get('id') == model.get('id')

    @itemViews = _itemViews

    if itemView
      current_position = $('.coverflow').coverflow('getCurrent')
      itemView.el.remove()
      $('.coverflow').coverflow('initItems')

      if current_position == 0
        @shift_carousel(1)
        @shift_carousel(-1)
      else
        @shift_carousel(-1)




  pageAdd: (models)->
    models.each(@addOne)
    @reloadCoverFlow()

  empty: ->
    $('.alert').remove()
    @.$el.empty()

  addAll: ->
    if (@collection.length > 0)
      @collection.each(@addOne)
    else
      @empty()

  addOne: (item) ->
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
    @

  select: (value) ->
    page = Math.ceil((value+1) / @collection.itemsPerPage)
    if @collection.pageLoaded(page)
      @.$el.coverflow 'select', value, false
    else
      @collection.loadPage page,
        success: =>
          @.$el.coverflow 'select', value, false

  shift: (e, value) ->
    e.preventDefault()
    e.stopPropagation()
    @shift_carousel(value)

  shift_carousel: (value) ->
    position = @.$el.coverflow('getCurrent') + value
    position = 0 if position < 0
    position = @collection.totalEntries - 1 if position >= @collection.totalEntries
    @.$el.coverflow 'select', position, false

  skipTo: (event, sky)->
    page = Math.ceil((sky.value+1) / @collection.itemsPerPage)
    @collection.loadPage(page - 1)
    @collection.loadPage(page + 1)
    @.slider.setValue(sky.value)

    _.each @itemViews, (el, id)->
      if sky.value == id
        el.renderFull()
      else
        el.renderPreview() unless el.status == 'preview' || el.status == 'fake'
    , @


  initCoverflow: (index) ->
    if @collection.length > 0
      index = 2 unless index?
      @defaultItem = _.min([index, @collection.length-1])
      @itemViews[@defaultItem].renderFull()
      @.slider.setValue(@defaultItem)

      @.$el.coverflow
        item: @defaultItem,
        duration: 1200,
        select: @skipTo


      left_btn = $('<div class="prev">prev</div>')
      right_btn = $('<div class="next">next</div>')
      $('#results').append left_btn, right_btn
