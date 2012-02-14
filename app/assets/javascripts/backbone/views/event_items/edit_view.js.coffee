Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EditView extends Backbone.View
  template : JST["backbone/templates/event_items/edit"]

  events :
    "submit #edit-event_item" : "update"

  constructor: (options) ->
    super(options)
    _.bindAll(this, "fillEventFields");

  fillEventFields: (fields)->
    @$('#event_type_fields').html(fields)
    @$(".datepicker").datepicker()
    @$("form").backboneLink(@model)

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
    $.get "/event_items/#{@model.id}/edit.html", @fillEventFields
    @$("form").backboneLink(@model)

    return this
