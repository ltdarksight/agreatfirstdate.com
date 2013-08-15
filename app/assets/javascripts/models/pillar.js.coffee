class Agreatfirstdate.Models.Pillar extends Backbone.Model

  initialize: (options)->
    @photos = new Agreatfirstdate.Collections.EventPhotos options.event_photos
    @eventItems = new Agreatfirstdate.Collections.EventItems options.event_items

  is_owner: ->
    _.include(Agreatfirstdate.currentProfile.pillar_ids(), @.get("id"))

  can: (action) ->
    Agreatfirstdate.currentProfile.fetch()
    switch action
      when "add_events" then @.is_owner()
      else false
