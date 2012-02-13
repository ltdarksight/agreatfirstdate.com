Agreatfirstdate.Views.EventPhotos ||= {}

class Agreatfirstdate.Views.EventPhotos.NewView extends Backbone.View
  template: JST["backbone/templates/event_photos/form"]

  events:
    "change .event_photo_image_": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()
    console.log @model
    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    @$("form").submit()
#    e.preventDefault()
#    e.stopPropagation()
#    @$('.upload-status_').html('Uploading...')
#    @model.unset("errors")
#    @collection.create(@model.toJSON(),
#      success: (event_item) =>
#        console.log event_item
#        @model = event_item
#        window.location.hash = ""
#
#      error: (event_item, jqXHR) =>
#        @model.set({errors: $.parseJSON(jqXHR.responseText)})
#    )

  render: ->
    $(@el).html(@template(@model.toJSON()))

    this.$("form").backboneLink(@model)
    return this
