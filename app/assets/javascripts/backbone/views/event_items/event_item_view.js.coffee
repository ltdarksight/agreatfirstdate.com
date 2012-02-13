Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventItemView extends Backbone.View
  template: JST["backbone/templates/event_items/event_item"]

  events:
    "click .destroy" : "destroy"

  tagName: "div"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSONRaw()))
    return this
