Agreatfirstdate.Views.EventPhotos ||= {}

class Agreatfirstdate.Views.EventPhotos.NewView extends Backbone.View
  events:
    "change .event_photo_image_": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    @collection.bind 'add', (model, collection) ->
      @render()
    , this

    @model.bind("change:errors", () =>
      this.render()
    )

  addAll: () =>
    @collection.each(@addOne)

  addOne: (eventPhoto) =>
    @$('.event_photos_previews_').append $('<img/>', {src: eventPhoto.toJSON().image.thumb.url})

  save: (e) ->
    @$('.upload-status_').html('Uploading...')
    @model.unset("errors")
    @$("form").submit()

  render: ->
    $(@el).html($("#event_photo_form").html())
    @addAll()
    return this
