Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EditView extends Backbone.View
  template : JST["backbone/event_items/edit"]

  events :
    "submit #edit-event_item" : "update"

  constructor: (options) ->
    super(options)
    @pillar = options.pillar
    @model.eventPhotos.bind 'add', (model, collection) ->
      $_eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id, id: "event_photo_#{model.id}_id"})
      @$('form').append $_eventPhotoId.hide()
      @$("form").backboneLink(@model)
    , this

    @model.eventPhotos.bind 'remove', (model, collection) ->
      @$("#event_photo_#{model.id}_id").remove()
      @$("form").backboneLink(@model)
    , this
    @model.on 'error', (model, data)->
      response = $.parseJSON(data.responseText)
      _.each response.errors, (errors, field)->
        @$(":input[name=#{field}]").after(@make("span", {"class": "error"}, _(errors).first()))
      , this
    , this

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @$('span.error').remove()
    @model.set('event_photo_ids', @model.eventPhotos.map (eventPhoto) -> eventPhoto.id)
    @model.save(null,
      success : (eventItem, response) =>
        @model = eventItem
        @model.set(response.event_item, silent: true)
        @model.calcDistance(response.event_item.date_1)
        @pillar.eventItems.sort({silent: true})
        @pillar.photos.reset response.pillar_photos
        window.location.hash = "/index"
    )

  render : ->
    $(@el).html(@template(@model.toJSON(false) ))
    unless @model.hasDate()
      @$('#event_type_fields').append(JST["backbone/event_items/date_field"]({label: 'Posted', value: @model.get('date_1'), name: 'date_1'}))

    fieldIds = {date: 1, string: 1, text: 1}
    _.each @model.toJSON(false).fields, (field)->
      @$('#event_type_fields').append(JST["backbone/event_items/#{field.field.split('_')[0]}_field"]({
        label: field.label,
        value: @model.get(field.field),
        name: field.field
      }))
    , this
    
    @model.eventPhotos.each (eventPhoto) ->
      @$('form').append $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: eventPhoto.id, id: "event_photo_#{eventPhoto.id}_id"}).hide()
    , this

    @$(".datepicker").datepicker()
    @$("form").backboneLink(@model)

    return this
