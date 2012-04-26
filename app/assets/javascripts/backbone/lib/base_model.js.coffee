class Agreatfirstdate.Models.BaseModel extends Backbone.Model
  truncate: (text, length, separator)->
    length_with_room = length - 3
    stop = text.lastIndexOf(separator, length_with_room) if separator?
    stop = length_with_room if !stop? || -1 == stop
    if text.length > length then text.substring(0, stop) + '...' else text

  toJSON: (filter = true)->
    json = _.clone(@attributes)
    if filter
      _.each @attributes, (value, key) ->
        if !_.include @accessibleAttributes, key
          delete json[key]
      , this
    json

  isPresent: (val)->
    !_.isNull(val) && val != ''
