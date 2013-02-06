class Agreatfirstdate.Models.Pillar extends Backbone.Model

  defaults:
    pillar_category: null

  initialize: (options)->
    @photos = new Agreatfirstdate.Collections.EventPhotos options.event_photos
