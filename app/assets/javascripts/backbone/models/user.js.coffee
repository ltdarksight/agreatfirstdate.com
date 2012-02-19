class Agreatfirstdate.Models.User extends Backbone.Model
  paramRoot: 'profile'
  url: '/me'
  defaults:
    who_am_i: null
    who_meet: ''

  sync: (method, model, options) ->
    model.trigger('sync')
    Backbone.sync(method, model, options)

  toJSON: (filter = true)->
    result = _.clone(@attributes)
    if filter
      _.each @attributes, (value, key) ->
        if !_.include ['id', 'avatars_attributes', 'who_am_i', 'who_meet'], key
          delete result[key]
      , this
    result