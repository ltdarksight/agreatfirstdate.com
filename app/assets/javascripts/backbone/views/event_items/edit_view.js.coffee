Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EditView extends Backbone.View
  template : JST["backbone/event_items/edit"]

  events :
    "submit #edit-event_item" : "update"

  constructor: (options) ->
    super(options)
    @model.eventPhotos.bind 'add', (model, collection) ->
      $_eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id, id: "event_photo_#{model.id}_id"})
      @$('form').append $_eventPhotoId.hide()
      @$("form").backboneLink(@model)
    , this

    @model.eventPhotos.bind 'remove', (model, collection) ->
      @$("#event_photo_#{model.id}_id").remove()
      @$("form").backboneLink(@model)
    , this

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.set('event_photo_ids', @model.eventPhotos.map (eventPhoto) -> eventPhoto.id)
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
    @model.eventPhotos.each (eventPhoto) ->
      @$('form').append $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: eventPhoto.id, id: "event_photo_#{eventPhoto.id}_id"}).hide()
    , this

    @$(".datepicker").datepicker()
    @$("form").backboneLink(@model)

    return this
