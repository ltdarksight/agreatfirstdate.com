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
    posted_at: null
    event_photo_ids: []

  initialize: (options) ->
    @eventPhotos = new Agreatfirstdate.Collections.EventPhotosCollection()
    @eventDescriptors = new Agreatfirstdate.Collections.EventDescriptorsCollection()
    if options
      @calcDistance(options.posted_at)
      @eventType = new Agreatfirstdate.Models.EventType(options.event_type if options.event_type)
      @eventDescriptors.reset @eventType.toJSON().event_descriptors if @eventType
      @eventPhotos.reset options.event_photos if options.event_photos

  calcDistance: (postedAt)->
    date = new Date()
    date.setTime(Date.parse(postedAt))
    @distance = Math.floor((new Date() - date)/(1000 * 60 * 60 * 24))

  toJSON: (filter = true)->
    result = _.clone(@attributes)
    if filter
      _.each @attributes, (value, key) ->
        if !_.include ['id', 'text_1', 'text_2', 'string_1', 'string_2', 'date_1', 'date_2', 'event_type_id', 'pillar_id', 'posted_at', 'event_photo_ids'], key
          delete result[key]
      , this
    result

class Agreatfirstdate.Collections.EventItemsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventItem

  initialize: (models, options)->
    super(models, options)
    @pillar = options.pillar

  toJSON: (filter = true) ->
    @map (model) -> return model.toJSON(filter)

  comparator: (eventItem) ->
    eventItem.distance

