Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowPhotosView extends Backbone.View
  template: JST["backbone/event_items/show/photos_wrapper"]
  previewTemplate: JST["backbone/event_items/show/photo_preview"]
  photoTemplate: JST["backbone/event_items/show/photo"]

  initialize: (options)->
    super options

  events:
    "click .thumbs a": "enlarge"

  enlarge: (e) ->
    photoId = $(e.currentTarget).attr('rel')
    @$('.photo').html(@photoTemplate(@model.eventPhotos.get(photoId).toJSON()))
    return false

  render: ->
    $(@el).html @template(@model.toJSON(false))
    @model.eventPhotos.each (eventPhoto) ->
      @$('.thumbs').append(@previewTemplate(eventPhoto.toJSON()))
    , this
    @$('.photo').html(@photoTemplate(@model.eventPhotos.first().toJSON()))
    return this
