Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.IndexView extends Backbone.View
  template: JST["backbone/event_items/index"]
  emptyTemplate: JST["backbone/event_items/empty"]
  dayHeight: 10
  className: 'event-items-wrapper'
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
    distance = eventItem.distance - @eventPosition
    offset = if distance == 0 then -1
    else if distance == 1 then 1
    else if distance < 5 then 2
    else if distance < 10 then 3
    else if distance < 20 then 4
    else 5

    view = new Agreatfirstdate.Views.EventItems.EventItemView({model: eventItem, id: 'event_item_'+eventItem.id, offset: offset*@dayHeight})
    $(@el).append(view.render().el)
    @eventPosition = eventItem.distance

  empty: =>
    @index()
    $(@el).append(@emptyTemplate(pillar: @options.pillar))

  index: =>
    $(@el).html(@template(eventItems: @eventItems.toJSON(false), pillar: @options.pillar))

  render: =>
    console.log 'resret'
    @addAll()
    return this
