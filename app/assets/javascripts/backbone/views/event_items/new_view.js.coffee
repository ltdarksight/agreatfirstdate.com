Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.NewView extends Backbone.View
  template: JST["backbone/templates/event_items/new"]

  events:
    "submit #new-event_item": "save"
    "change #pillar_id": "loadTypes"
    "change #event_type_id": "loadFields"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)
    @model.bind("change:errors", () =>
      this.render()
    )
    _.bindAll(this, "fillEventFields");

  loadFields: (e) ->
    event_type_id = $(e.target).val()
    $.get "/event_types/#{event_type_id}/event_descriptors.html", @fillEventFields

  fillEventFields: (fields)->
    @$('#event_type_fields').html(fields)
    @$(".datepicker").datepicker()

  loadTypes: (e) ->
    @pillar = @pillars.get $(e.target).val()
    window.location.hash = "/pillars/#{@pillar.id}/event_items/new"
    @model.set('pillar_id', @pillar.id)

  fillTypes: (eventTypes) ->
    $_eventTypes = @$('#event_type_id')
    $_eventTypes.empty()

    _.each eventTypes.toJSON(), (eventType, id, list) ->
      $_eventTypes.append($('<option/>', {value: eventType.id}).html(eventType.title))
    $_eventTypes.trigger 'change'

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    _.each ['date_1', 'date_2', 'text_1', 'text_2', 'string_1', 'string_2'], (fieldName) ->
      $_field = @$("##{fieldName}")
      @model.set fieldName, $_field.val() if $_field.length
    , this
    @model.unset("errors")
    @collection.create(@model.toJSON(),
      success: (event_item) =>
        @model = event_item
        window.location.hash = ""

      error: (event_item, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSONRaw()))

    this.$("form").backboneLink(@model)
    return this
