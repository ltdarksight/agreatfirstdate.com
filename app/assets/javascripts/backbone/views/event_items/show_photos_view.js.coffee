Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowPhotosView extends Backbone.View
  template: JST["backbone/event_items/show/photos_wrapper"]
  previewTemplate: JST["backbone/event_items/show/photo_preview"]
  photoTemplate: JST["backbone/event_items/show/photo"]

  currentPhotoId: null

  initialize: (options)->
    super options

  events:
    "click .thumbs a": "enlarge"
    "click .next": "next"
    "click .prev": "prev"

  enlarge: (e) ->
    e.preventDefault()
    @currentPhoto = @model.eventPhotos.get(parseInt($(e.currentTarget).attr('rel')))
    @showLarge()

  showLarge: ->
    @$('.photo').html(@photoTemplate(@currentPhoto.toJSON()))

  next: (e)->
    e.preventDefault()
    currentIndex = @model.eventPhotos.indexOf @currentPhoto
    @currentPhoto = @model.eventPhotos.at(if @model.eventPhotos.length-1 == currentIndex then 0 else currentIndex+1)
    @showLarge()

  prev: (e)->
    e.preventDefault()
    currentIndex = @model.eventPhotos.indexOf @currentPhoto
    @currentPhoto = @model.eventPhotos.at((if 0 == currentIndex then @model.eventPhotos.length else currentIndex) - 1)
    @showLarge()


  render: ->
    $(@el).html @template(@model.toJSON(false))
    @model.eventPhotos.each (eventPhoto) ->
      @$('.thumbs').append(@previewTemplate(eventPhoto.toJSON()))
    , this
    if @model.eventPhotos.length
      @currentPhoto = @model.eventPhotos.first()
      @showLarge()
    return this
