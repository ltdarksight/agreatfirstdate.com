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
      success : (event_item) =>
        @model = event_item
        @model.calcDistance(event_item.toJSON().date_1)
        @pillar.eventItems.sort({silent: true})
        window.location.hash = "/index"
    )

  render : ->
    $(@el).html(@template(@model.toJSON(false) ))
    unless @model.hasDate
      @$('#event_type_fields').append(JST["backbone/event_items/date_field"]({label: 'Posted', value: @model.get('date_1'), name: 'date_1'}))


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
