class Agreatfirstdate.Collections.EventPhotos extends Backbone.Collection
  model: Agreatfirstdate.Models.EventPhoto
  url: 'api/event_photos'

  current: ->
    @first()
