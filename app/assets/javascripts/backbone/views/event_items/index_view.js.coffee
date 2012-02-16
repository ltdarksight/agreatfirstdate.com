Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.IndexView extends Backbone.View
  template: JST["backbone/event_items/index"]
  emptyTemplate: JST["backbone/event_items/empty"]
  dayHeight: 50

  initialize: () ->
    @eventItems = @options.eventItems
    @eventItems.bind('reset', @addAll)

  addAll: () =>
    if (@eventItems.length > 0)
      @index()
      @eventPosition = 0
      @eventItems.each(@addOne)
    else
      @empty()

  addOne: (eventItem) =>
    @eventPosition += @dayHeight*eventItem.distance
    view = new Agreatfirstdate.Views.EventItems.EventItemView({model: eventItem, id: 'event_item_'+eventItem.id, position: @eventPosition})
    $(@el).append(view.render().el)

  empty: =>
    @index()
    $(@el).append(@emptyTemplate(pillar: @options.pillar))

  index: =>
    $(@el).html(@template(eventItems: @eventItems.toJSON(false), pillar: @options.pillar))

  render: =>
    @addAll()
    return this
