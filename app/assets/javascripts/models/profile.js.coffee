class Agreatfirstdate.Models.Profile extends Backbone.Model


  methodUrl:
    'activate':
      path: '/api/profiles/:id/activate'
      method: 'read'
    'deactivate':
      path: '/api/profiles/:id/deactivate'
      method: 'update'

  initialize: (options) ->
    @avatars = new Agreatfirstdate.Collections.Avatars(options.avatars)
    @strikes = new Agreatfirstdate.Collections.StrikesCollection(options.strikes)

  activate: (options)->
    return false if @.isNew()

    options = if options then _.clone(options) else {}
    if _.include _(@methodUrl).keys(), 'activate'
      urlOptions = @methodUrl['activate']
      options.url = urlOptions['path'].replace(':id', @.get('id'))
      method = urlOptions['method']
      Backbone.sync(method, @, options)

    true

  deactivate: (options)->
    return false if @.isNew()

    options = if options then _.clone(options) else {}
    if _.include _(@methodUrl).keys(), 'deactivate'
      urlOptions = @methodUrl['deactivate']
      options.url = urlOptions['path'].replace(':id', @.get('id'))
      method = urlOptions['method']
      Backbone.sync(method, @, options)

    true


  favoriteUsers: ->
    new Agreatfirstdate.Collections.UserFavoritesCollection @get("favorite_users")

  is_current: ->
    Agreatfirstdate.currentProfile.get("id") == @get("id")

  can: (action) ->
    switch action
      when "read" then true
      when "edit" then @is_current()
      when "add_avatar" then @is_current()
      when "edit_avatar" then @is_current()
      else false

  is_admin: ->
    @.get("role") == 'admin'

  is_user: ->
    @.get("role") == 'user'

  can_activate: (target) ->
    @is_admin() and (target.get('status') != 'active')

  can_deactivate: (target) ->
    @is_admin() and (target.get('status') == 'active')

  pillar_ids: ->

    @.get("pillars").map (item) ->
      item["id"]

  oppositeSex: ->
    if @.get("gender") == "male"
      "female"
    else
      "male"

  profileCompleted: ->
    @.toJSON().pillars.length > 0

