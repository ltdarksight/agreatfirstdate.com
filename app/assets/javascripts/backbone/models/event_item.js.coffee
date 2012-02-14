class Agreatfirstdate.Models.EventItem extends Backbone.Model
  paramRoot: 'event_item'

  defaults:
    id: null
    text_1: null
    text_2: null
    string_1: null
    string_2: null
    date_1: null
    date_2: null
    event_type_id: null
    pillar_id: null
    created_at: null
    event_photo_ids: []

  initialize: (options) ->
    @eventPhotos = new Agreatfirstdate.Collections.EventPhotosCollection()
    if options && options.event_photos
      @eventPhotos.reset options.event_photos

  toJSON: (filter = true)->
    result = _.clone(@attributes)
    if filter
      _.each @attributes, (value, key) ->
        if !_.include ['id', 'text_1', 'text_2', 'string_1', 'string_2', 'date_1', 'date_2', 'event_type_id', 'pillar_id', 'created_at', 'event_photo_ids'], key
          delete result[key]
      , this
    result

class Agreatfirstdate.Collections.EventItemsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventItem

  toJSON: (filter = true) ->
    @map (model) -> return model.toJSON(filter)


