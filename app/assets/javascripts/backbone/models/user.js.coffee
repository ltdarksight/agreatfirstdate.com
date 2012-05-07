class Agreatfirstdate.Models.User extends Agreatfirstdate.Models.BaseModel
  paramRoot: 'profile'
  url: '/me'
  methodUrl:
    'activate': '/profiles/:id/activate'
    'deactivate': '/profiles/:id/deactivate'
    'still_inappropriate': '/profiles/:id/still_inappropriate'

  defaults:
    who_am_i: ''
    who_meet: ''
    in_or_around: 'Denver, CO'
    gender: 'male'
    looking_for: 'female'
    avatar: {image: {thumb: {url: '/assets/defaults/avatar/thumb.jpg'}, preview: {url: '/assets/defaults/avatar/preview.jpg'}, search_thumb: {url: '/assets/defaults/avatar/search_thumb.jpg'}}}
    card_expiration: ''
    card_number: ''
    card_cvc: ''
    card_type: ''
    canceled: '0'
  accessibleAttributes: ['who_am_i', 'who_meet', 'avatars_attributes', 'gender', 'looking_for_age', 'first_name', 'last_name', 'age', 'looking_for',
                         'favorites_attributes', 'strikes_attributes', 'canceled']

  initialize: (options)->
    @allowEdit = options.allowEdit
    @avatars = new Agreatfirstdate.Collections.AvatarsCollection(options.avatars)
    @favoriteUsers = new Agreatfirstdate.Collections.FavoriteUsersCollection(options.favorite_users)
    @strikes = new Agreatfirstdate.Collections.StrikesCollection(options.strikes)
    @inappropriateContent = new Agreatfirstdate.Models.InappropriateContent(options.inappropriate_content)
    @inappropriateContents = new Agreatfirstdate.Collections.InappropriateContentsCollection(options.inappropriate_contents)

  sync: (method, model, options) =>
    options = options || {}
    if _.include _(@methodUrl).keys(), method
      options.url = @methodUrl[method.toLowerCase()].replace(':id', model.id);
      method = 'update'
    Backbone.sync(method, model, options)

  toJSON: (filter = true)->
    json = super filter
    if filter
      json
    else
      $.extend(json,
        avatar: (if @avatars.length then @avatars.current().toJSON() else (if @allowEdit then null else @defaults.avatar)),
        avatars: @avatars.toJSON(),
        allowEdit: @allowEdit,
        who_am_i_short: @truncate(json.who_am_i, 250),
        who_meet_short: @truncate(json.who_meet, 300))

  fetchPoints: =>
    @fetch({url: '/me/points'})

  is: (role) =>
    @get('role') == role

  active: =>
    'active' == @get('status')

  canceled: =>
    'canceled' == @get('status')

  locked: =>
    'locked' == @get('status')

  fullName: =>
    "#{@get('first_name')} #{@get('last_name')}"

class Agreatfirstdate.Models.UserSettings extends Agreatfirstdate.Models.User
  url: '/me/billing'
  defaults:
    card_expiration: ''
    card_number: ''
    card_cvc: ''
    card_type: ''
    first_name: ''
    last_name: ''
    address: ''
    zip: ''
  accessibleAttributes: ['gender', 'looking_for', 
                         'first_name', 'last_name', 'address1', 'address2', 'zip', 'city', 'state',
                         'card_number', 'card_expiration', 'card_cvc', 'card_type', 'stripe_card_token']

  validate: (attrs)->
    @unset 'errors', silent: true
    unless attrs['card_provided?']
      @validateCardNumber(attrs, 'card_number')
      @validateCardExpiration(attrs, 'card_expiration')
      @validateCardCvc(attrs, 'card_cvc')
      if attrs.card_number != ''
        @validatePresenceOf(attrs, 'card_expiration')
        @validatePresenceOf(attrs, 'card_cvc')

    @trigger('change:errors', this, @get('errors'))
    @get 'errors'

  validatePresenceOf: (attrs, attr)->
    errors = {}
    if attrs[attr] == ''
      errors[attr] = ["can't be blank"]
      @set 'errors', $.extend(@get('errors'), errors), {silent: true}
    @set(attr, attrs[attr], silent: true)

  validateCardNumber: (attrs, attr)->
    errors = {}
    if attrs[attr] != '' && !Stripe.validateCardNumber attrs[attr]
      errors[attr] = ["invalid card number"]
      @set 'errors', $.extend(@get('errors'), errors), {silent: true}

    @set(attr, attrs[attr], silent: true)
    @set('card_type', Stripe.cardType(attrs[attr]), silent: true)
    @trigger('change:card_type', this, @get('card_type'))

  validateCardExpiration: (attrs, attr)->
    errors = {}
    if attrs[attr] != ''
      date = attrs[attr].split('/')
      unless date.length == 2 || Stripe.validateExpiry date[0], "20#{date[1]}"
        errors[attr] = ["invalid date"]
        @set 'errors', $.extend(@get('errors'), errors), {silent: true}

    @set(attr, attrs[attr], silent: true)

  validateCardCvc: (attrs, attr)->
    errors = {}
    if attrs[attr] != '' && !Stripe.validateCVC attrs[attr]
      errors[attr] = ["invalid CVC"]
      @set 'errors', $.extend(@get('errors'), errors), {silent: true}
    @set(attr, attrs[attr], silent: true)

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

  removeItem: (model, options)->
    @totalEntries--
    index = @indexOf model
    @remove(model, options)
    _.each @models, (model, i)=> model.position = i
    @trigger('removeItem', this, index)

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
