Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventPreviewView extends Backbone.View
  template: JST["backbone/event_items/show/event_item_preview"]
  className: 'event-preview'

  initialize: (options) ->
    super
    @photo = if @model.eventPhotos.length then @model.eventPhotos.first().toJSON() else false

  events:
    "click" : "show"

  show: ->
    location.hash = "#/pillars/#{@model.get('pillar_id')}/event_items/#{@model.id}"

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false), photo: @photo))
    return this
