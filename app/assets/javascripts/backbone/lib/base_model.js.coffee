class Agreatfirstdate.Models.BaseModel extends Backbone.Model
  truncate: (text, length)->
    if text.length then text.substring(0, length) + (if text.length > length then '...' else '') else ''

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