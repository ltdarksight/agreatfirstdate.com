class Agreatfirstdate.Models.User extends Backbone.Model
  paramRoot: 'profile'
  url: '/me'
  defaults:
    who_am_i: ''
    who_meet: ''

  initialize: (options)->
    @avatars = new Agreatfirstdate.Collections.AvatarsCollection(options.avatars)
    _.bindAll(this, 'validate')

  searchTerms: ->
    result = _.clone(@attributes)
    _.each @attributes, (value, key) ->
      if !_.include ['gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around', 'match_type', 'pillar_ids'], key
        delete result[key]
    , this
    result

  sync: (method, model, options) ->
    model.trigger('sync')
    Backbone.sync(method, model, options)

#  validate:
#    looking_for_age_from : {
#      type: "number",
#      min: 12,
#      max: 100
#    }
#    looking_for_age_to: {
#      type: "number",
#      min: 12,
#      max: 100
#    }
  validate: (attrs)->
    from = attrs.looking_for_age_from
    to = attrs.looking_for_age_to
    if @isPresent(from)
      fromStatus = @validateAge(from)
      unless fromStatus.status
        @set({looking_for_age_from: ''})
        return fromStatus.message
    if @isPresent(to)
      toStatus = @validateAge(to)
      unless toStatus.status
        @set({looking_for_age_to: ''})
        return toStatus.message
    if @isPresent(to) && @isPresent(from)
      if parseInt(from) > parseInt(to)
        @set({looking_for_age_to: ''})
        return "invalid range"

  isPresent: (val)->
    !_.isNull(val) && val != ''

  validateAge: (val)->
    message = if isNaN(parseFloat(val)) || !isFinite(val)
      "#{val} id not a valid integer"
    else if parseInt(val) < 14 || parseInt(val) > 100
      "#{val}: invalid age"
    {status: _.isUndefined(message), message: message}

class Agreatfirstdate.Collections.SearchResultsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: '/searches'
