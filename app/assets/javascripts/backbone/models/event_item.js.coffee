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

  set: (attrs, value, options) ->
    if _.isObject(attrs)
      @raw_attributes = _.clone attrs
      _.each attrs, (value, key) ->
        if !_.include ['id', 'text_1', 'text_2', 'string_1', 'string_2', 'date_1', 'date_2', 'event_type_id', 'pillar_id', 'created_at'], key
          delete attrs[key]
      , this

    super attrs, value, options

  toJSONRaw: ->
    _.clone(@raw_attributes)

class Agreatfirstdate.Collections.EventItemsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventItem

  toJSONRaw: ->
    @map (model) -> return model.toJSONRaw()


