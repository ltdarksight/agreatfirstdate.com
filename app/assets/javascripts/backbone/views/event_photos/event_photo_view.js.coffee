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

  render: (allowDelete = false)->
    $(@el).html(@template(@model.toJSON(false)))
    if allowDelete
      $(@el).append($('<a/>', {class: 'destroy'}).html('Delete'))
    return this
