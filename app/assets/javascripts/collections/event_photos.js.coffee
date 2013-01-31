class Agreatfirstdate.Collections.EventPhotosCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventPhoto
  url: '/event_photos'

  current: ()->
    @first()