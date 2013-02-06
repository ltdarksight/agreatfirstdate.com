class Agreatfirstdate.Collections.EventPhotos extends Backbone.Collection
  model: Agreatfirstdate.Models.EventPhoto
  url: '/event_photos'

  current: ()->
    @first()