Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.NewView extends Backbone.View
  template: JST["backbone/event_items/new"]

  events:
    "submit #new-event_item": "save"
    "change #pillar_id": "loadTypes"
    "change #event_type_id": "showFields"

  constructor: (options) ->
    super(options)
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)

    @model = new @pillar.eventItems.model()

    @model.eventPhotos = new Agreatfirstdate.Collections.EventPhotosCollection()
    @model.eventTypes = new Agreatfirstdate.Collections.EventTypesCollection()
    @model.eventTypes.url = '/pillars/'+@pillar.id+'/event_types'
    @model.eventTypes.fetch {success: @fillTypes}

    @model.eventPhotos.bind 'add', (model, collection) ->
      $_eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id, id: "event_photo_#{model.id}_id"})
      @$('form').append $_eventPhotoId.hide()
      @$("form").backboneLink(@model)
    , this

    @model.eventPhotos.bind 'remove', (model, collection) ->
      @$("#event_photo_#{model.id}_id").remove()
      @$("form").backboneLink(@model)
    , this

    @model.bind("change:errors", () =>
      this.render()
    )

  showFields: (e) ->
    eventTypeId = $(e.target).val()
    @model.eventType = @model.eventTypes.get(eventTypeId)
    fieldIds = {date: 1, string: 1, text: 1}
    @model.eventDescriptors = @model.eventTypes.get(eventTypeId).eventDescriptors
    @$('#event_type_fields').empty()
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
    params = $.extend @model.toJSON(false),
        event_photos: @model.eventPhotos.toJSON()
        event_type: @model.eventTypes.get(@model.get('event_type_id')).toJSON()

    @pillar.eventItems.create(params,
      success: (eventItem) =>
        @model = eventItem
        @model.calcDistance(eventItem.toJSON().posted_at)
        @pillar.eventItems.sort()
        window.location.hash = "/index"

      error: (eventItem, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    _.each @pillars.toJSON(), (pillar, id, list) ->
      $_el = $('<option/>', {value: pillar.id}).html(pillar.name)
      $_el.attr('selected', 'selected') if (pillar.id == @pillar.id)
      @$('#pillar_id').append($_el)
    , this

    this.$("form").backboneLink(@model)
    return this
