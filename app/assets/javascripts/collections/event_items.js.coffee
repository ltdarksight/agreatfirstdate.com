class Agreatfirstdate.Collections.EventItems extends Backbone.Collection
  model: Agreatfirstdate.Models.EventItem
  url: 'api/event_items'

  comparator: (eventItem) ->
    eventItem.distance

  previousTo: (current)->
    if @length > 2
      @at (if 0 == current then @length else current) - 1
    else if @length == 2 && current == 1
      @at 0
    else
      false

  nextTo: (current)->
    if @length > 2
      @at if @length - 1 == current then 0 else current + 1
    else if @length == 2 && current == 0
      @at 1
    else
      false