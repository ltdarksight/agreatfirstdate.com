Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Index extends Backbone.View
  template: JST['event_items/index']
  dayHeight: 10
  tagName: "div"
  className: 'event-items-wrapper'

  initialize: (options) ->
    @pillar = options.pillar
    @eventItems = @pillar.eventItems

  addAll: ->
    if (@eventItems.length > 0)
      @eventItems.each(@addOne)
    #   @index()
    #   @eventPosition = 0
    #   @eventItems.each(@addOne)
    # else
    #   @empty()

  addOne: (eventItem) =>
    distance = eventItem.distance - @eventPosition
    offset = if distance == 0 then -1
    else if distance == 1 then 1
    else if distance < 5 then 2
    else if distance < 10 then 3
    else if distance < 20 then 4
    else 5

    view = new Agreatfirstdate.Views.EventItems.EventItem(
      model: eventItem
      id: 'event_item_'+eventItem.id
      offset: offset*@dayHeight
    )

    $(@el).append view.render().el

  empty: =>
    @index()
    $(@el).append(@emptyTemplate(pillar: @options.pillar))

  render: ->
    $(@el).html @template(pillar: @pillar)
    @addAll()
    this
