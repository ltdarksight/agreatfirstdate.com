Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowView extends Backbone.View
  template: JST["backbone/templates/event_items/show"]

  render: ->
    $(@el).html(@template(@model.toJSONRaw() ))
    return this
