class Agreatfirstdate.Models.User extends Backbone.Model

  methodUrl:
    'activate': '/profiles/:id/activate'
    'deactivate': '/profiles/:id/deactivate'
    'still_inappropriate': '/profiles/:id/still_inappropriate'
    'facebook_albums': '/profiles/:id/facebook_albums'

  defaults:
  #   who_am_i: ''
  #   who_meet: ''
  #   in_or_around: 'Denver, CO'
  #   gender: 'male'
  #   looking_for: 'female'
    avatar: {image: {thumb: {url: '/assets/defaults/avatar/thumb.jpg'}, preview: {url: '/assets/defaults/avatar/preview.jpg'}, search_thumb: {url: '/assets/defaults/avatar/search_thumb.jpg'}}}
  #   card_expiration: ''
  #   card_number: ''
  #   card_cvc: ''
  #   card_type: ''
  #   canceled: '0'

  initialize: (options)->
    # @allowEdit = options.allowEdit
    # @avatars = new Agreatfirstdate.Collections.AvatarsCollection(options.avatars)
    # @favoriteUsers = new Agreatfirstdate.Collections.FavoriteUsersCollection(options.favorite_users)
    # @strikes = new Agreatfirstdate.Collections.StrikesCollection(options.strikes)
    # @inappropriateContent = new Agreatfirstdate.Models.InappropriateContent(options.inappropriate_content)
    # @inappropriateContents = new Agreatfirstdate.Collections.InappropriateContentsCollection(options.inappropriate_contents)

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

class Agreatfirstdate.Collections.FavoriteUsersCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User


class Agreatfirstdate.Collections.OppositeSexCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.User
  url: '/searches/opposite_sex'