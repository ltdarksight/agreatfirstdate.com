Agreatfirstdate.Views.EventPhotos ||= {}

class Agreatfirstdate.Views.EventPhotos.EventPhotoView extends Backbone.View
  template: JST["backbone/event_photos/event_photo"]

  events:
    "click .destroy" : "destroy"

  tagName: "div"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    return this
