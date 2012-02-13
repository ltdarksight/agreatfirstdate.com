class Agreatfirstdate.Models.EventPhoto extends Backbone.Model
  paramRoot: 'event_photo'

  defaults:
    image: null

class Agreatfirstdate.Collections.EventPhotosCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventPhoto
  url: '/event_photos'
