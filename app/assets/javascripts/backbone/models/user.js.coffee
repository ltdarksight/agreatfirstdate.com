class Agreatfirstdate.Models.User extends Agreatfirstdate.Models.BaseModel
  paramRoot: 'profile'
  url: '/me'
  defaults:
    who_am_i: ''
    who_meet: ''
    in_or_around: 'Denver, CO'
    gender: 'male'
    avatar: {image: {thumb: {url: '/assets/defaults/avatar/thumb.jpg'}, preview: {url: '/assets/defaults/avatar/preview.jpg'}, search_thumb: {url: '/assets/defaults/avatar/search_thumb.jpg'}}}
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
      $.extend(json,
        avatar: (if @avatars.length then @avatars.current().toJSON() else (if @allowEdit then null else @defaults.avatar)),
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
  itemsPerPage: 5
  loadedPages: []
  addCallback: null

  add: (data, options)->
    @page = parseInt data.page

    @totalEntries = data.total_entries
    super data.results
    models = []
    _.each @models, (model)=>
      if _.isUndefined(model.position)
        model.position = models.length + (@page-1)*@itemsPerPage
        models.push(model)
    if @page == 1
      @trigger('resetCollection', this)
      @loadedPages = []
    else
      @trigger('pageAdd', models)

    @loadedPages.push(@page)
    @addCallback() if @addCallback
    @addCallback = null

  pageLoaded: (page)->
    return true if page < 1 || Math.ceil(@totalEntries/@itemsPerPage) < page
    _.include @loadedPages, page

  loadPage: (page, options)->
    options = if options then _.clone(options) else {}
    @addCallback = options.success
    @fetch(data: $.extend(@userSearch.searchTerms(), page: page), add: true) unless @pageLoaded(page)

class Agreatfirstdate.Collections.FavoriteUsersCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User


class Agreatfirstdate.Collections.OppositeSexCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: '/searches/opposite_sex'
