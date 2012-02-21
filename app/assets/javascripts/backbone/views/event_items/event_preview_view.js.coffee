Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventPreviewView extends Backbone.View
  template: JST["backbone/event_items/show/event_item_preview"]
  className: 'event-preview'

  initialize: (options) ->
    super

  events:
    "click" : "show"

  show: ->
    location.hash = "#/pillars/#{@model.get('pillar_id')}/event_items/#{@model.id}"

  render: ->
    $(@el).html @template(@model.toJSON(false))
    return this
