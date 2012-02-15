Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowView extends Backbone.View
  template: JST["backbone/event_items/show"]

  render: ->
    $(@el).html(@template(@model.toJSON(false) ))
    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/field"]({label: value.label, value: fieldValue}))
    , this
    return this
