Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Index extends Backbone.View
  
  template: JST["search/index"]
  emptyTemplate: JST["search/empty"]
  el: '#results'
  itemViews: []

  initialize: (options) ->
    
    i = 0
    @collection.each (model) ->
      view = new Agreatfirstdate.Views.Search.ResultItem(
        # me: @me
        collection: @collection
        model: model
      )
      
      $(@el).append(view.renderFake().el)
      @itemViews[i++] = view
    , this
    

  empty: ->  
    $(@el).html(@emptyTemplate())
    this
    
  addAll: ->
    if (@collection.length > 0)
      @collection.each(@addOne)
    else
      @empty()
      
  addOne: (item) =>
    view = @itemViews[item.position]
    view.model = item
    view.renderPreview()
    
  render: ->
    @addAll()
    this
      
  initCoverflow: (index) =>
    if @collection.length
      index = 2 unless index?
      @defaultItem = _.min([index, @collection.length-1])
      @coverflowCtrl = $('#results > div')
      @itemViews[@defaultItem].renderFull()
      $(@slider).slider('option', 'value', @defaultItem)

      @coverflowCtrl.coverflow
        item: @defaultItem,
        duration: 1200,
        select: @skipTo

      left_btn = $('<div class="prev">prev</div>').click => @shift(-1)
      right_btn = $('<div class="next">next</div>').click => @shift(1)
      $('#results').append left_btn, right_btn
    