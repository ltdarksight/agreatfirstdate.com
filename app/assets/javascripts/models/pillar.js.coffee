class Agreatfirstdate.Models.Pillar extends Backbone.Model

  initialize: (options)->
    @photos = new Agreatfirstdate.Collections.EventPhotos options.event_photos
