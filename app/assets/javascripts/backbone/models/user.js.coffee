class Agreatfirstdate.Models.User extends Agreatfirstdate.Models.BaseModel
  paramRoot: 'profile'
  url: '/me'
  defaults:
    who_am_i: ''
    who_meet: ''

  accessibleAttributes: ['who_am_i', 'who_meet', 'avatars_attributes', 'gender', 'looking_for_age', 'first_name', 'last_name', 'age', 'looking_for', 'favorites_attributes']

  initialize: (options)->
    @allowEdit = options.allowEdit
    @avatars = new Agreatfirstdate.Collections.AvatarsCollection(options.avatars)
    @favoriteUsers = new Agreatfirstdate.Collections.FavoriteUsersCollection(options.favorite_users)
    _.bindAll(this, 'validate')

  validate: (attrs)->
    null

  sync: (method, model, options) ->
    model.trigger('sync')
    Backbone.sync(method, model, options)

  toJSON: (filter = true)->
    json = super filter
    if filter
      json
    else
      $.extend(json, avatar: (if @avatars.length then @avatars.current().toJSON() else null),
        allowEdit: @allowEdit,
        who_am_i_short: @truncate(json.who_am_i, 250),
        who_meet_short: @truncate(json.who_meet, 300))

class Agreatfirstdate.Models.UserSearch extends Agreatfirstdate.Models.User
  accessibleAttributes: ['favorites_attributes']
  searchTerms: ->
    result = _.clone(@attributes)
    _.each @attributes, (value, key) ->
      if !_.include ['gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around', 'match_type', 'pillar_category_ids'], key
        delete result[key]
    , this
    result
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

  validateAge: (val)->
    message = if isNaN(parseFloat(val)) || !isFinite(val)
      "#{val} id not a valid integer"
    else if parseInt(val) < 14 || parseInt(val) > 100
      "#{val}: invalid age"
    {status: _.isUndefined(message), message: message}

class Agreatfirstdate.Collections.SearchResultsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: '/searches'
  page: 1
  totalEntries: 0

  add: (data, options)->
    @page = parseInt data.page
    @totalEntries = data.total_entries
    super data.results

class Agreatfirstdate.Collections.FavoriteUsersCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User


class Agreatfirstdate.Collections.OppositeSexCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: '/searches/opposite_sex'
  page: 1
  totalEntries: 0

  add: (data, options)->
    @page = parseInt data.page
    @totalEntries = data.total_entries
    super data.results