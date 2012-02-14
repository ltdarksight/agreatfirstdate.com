Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.NewView extends Backbone.View
  template: JST["backbone/templates/event_items/new"]

  events:
    "submit #new-event_item": "save"
    "change #pillar_id": "loadTypes"
    "change #event_type_id": "showFields"

  constructor: (options) ->
    super(options)
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)

    @model = new @pillar.eventItems.model()
    @pillar.eventItems.currentNewModel = @model
    @model.eventPhotos = new Agreatfirstdate.Collections.EventPhotosCollection()
    @model.eventTypes = new Agreatfirstdate.Collections.EventTypesCollection()
    @model.eventTypes.url = '/pillars/'+@pillar.id+'/event_types'
    @model.eventTypes.fetch {success: @fillTypes}

    @model.eventPhotos.bind 'add', (model, collection) ->
      $_eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id})
      @$('form').append $_eventPhotoId.outerHtml()
      @$("form").backboneLink(@model)
    , this

    @model.bind("change:errors", () =>
      this.render()
    )

  showFields: (e) ->
    eventTypeId = $(e.target).val()
    fieldIds = {date: 1, string: 1, text: 1}
    @model.eventDescriptors = @model.eventTypes.get(eventTypeId).eventDescriptors
    @$('#event_type_fields').empty()
    _.each @model.eventDescriptors.toJSON(), (descriptor)->
      name = "#{descriptor.field_type}_#{fieldIds[descriptor.field_type]++}"
      @$('#event_type_fields').append(JST["backbone/templates/event_items/#{descriptor.field_type}_field"]({
        label: descriptor.title,
        value: @model.get(name),
        name: name
      }))
    , this
    @$(".datepicker").datepicker()
    @$("form").backboneLink(@model)

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

    @model.set('event_photo_ids', _.map(@$('input[name="event_photo_ids[]"]'), (el) -> $(el).val()))

    @model.unset("errors")
    @pillar.eventItems.create(@model.toJSON(),
      success: (event_item) =>
        @model = event_item
        @pillar.eventItems.sort()
        window.location.hash = ""

      error: (event_item, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON(false)))

    this.$("form").backboneLink(@model)
    return this
