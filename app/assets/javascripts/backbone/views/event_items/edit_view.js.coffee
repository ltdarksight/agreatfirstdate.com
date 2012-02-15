Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EditView extends Backbone.View
  template : JST["backbone/event_items/edit"]

  events :
    "submit #edit-event_item" : "update"

  constructor: (options) ->
    super(options)

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (event_item) =>
        @model = event_item
        window.location.hash = ""
    )

  render : ->
    $(@el).html(@template(@model.toJSON(false) ))
    fieldIds = {date: 1, string: 1, text: 1}
    _.each @model.eventDescriptors.toJSON(), (descriptor)->
      name = "#{descriptor.field_type}_#{fieldIds[descriptor.field_type]++}"
      @$('#event_type_fields').append(JST["backbone/event_items/#{descriptor.field_type}_field"]({
        label: descriptor.title,
        value: @model.get(name),
        name: name
      }))
    , this
    @$(".datepicker").datepicker()
    @$("form").backboneLink(@model)

    return this
