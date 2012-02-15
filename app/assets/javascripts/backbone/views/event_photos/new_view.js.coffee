Agreatfirstdate.Views.EventPhotos ||= {}

class Agreatfirstdate.Views.EventPhotos.NewView extends Backbone.View
  template: JST["backbone/event_photos/form"]
  preview: JST["backbone/event_photos/preview"]

  events:
    "change .event_photo_image_": "save"

  constructor: (options) ->
    super(options)
    @pillar = options.pillar
    @model = new @collection.model()
    @collection.bind 'add', (model, collection) ->
      @render()
    , this

    @model.bind("change:errors", () =>
      this.render()
    )
    options.eventItem.bind("change:event_type_id", (model, value) =>
      @$("form").toggle model.eventTypes.get(value).get('has_attachments')
    )

  addAll: () =>
    @collection.each(@addOne)

  addOne: (eventPhoto) =>
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    @$('.event_photos_previews_').append(view.render(true).el)

  save: (e) ->
    @$('.upload-status_').html('Uploading...')
    @model.unset("errors")
    @$("form").submit()

  render: ->
    $(@el).html($("#event_photo_form").html())
    @$('#pillar_id').val(@pillar.id)
#    $(@el).html(@template())
    @addAll()
    return this
