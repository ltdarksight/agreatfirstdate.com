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

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    _.each ['date_1', 'date_2', 'text_1', 'text_2', 'string_1', 'string_2'], (fieldName) ->
      $_field = @$("##{fieldName}")
      @model.set fieldName, $_field.val() if $_field.length
    , this

    @model.save(null,
      success : (event_item) =>
        @model = event_item
        window.location.hash = ""
    )

  render : ->
    $(@el).html(@template(@model.toJSONRaw() ))
    $.get "/event_items/#{@model.id}/edit.html", @fillEventFields
    this.$("form").backboneLink(@model)

    return this
