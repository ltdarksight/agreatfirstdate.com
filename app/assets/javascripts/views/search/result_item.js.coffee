Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItem extends Backbone.View
  fakeTemplate: JST['search/result_item_fake']
  template: JST['search/result_item']
  pillarTemplate: JST['search/result_item_pillar']
  previewTemplate: JST["search/result_item_preview"]

  className: 'result-item'
  status: 'preview'

  events:
    "click .add-to-favorites_": "addToFavorites"
    "click .strikes_": "strike"

  initialize: (options) ->
    @me  = Agreatfirstdate.current_profile
    _.bindAll @, "addToFavorites"
    _.bindAll @, "strike"
    _.bindAll @, "show"

  toggleAddToFavorites: (collection)->
    if @model && @model.id != @me.id
      r = _.isUndefined(collection.find((user)->
         user.id == @model.id
        , @))

      @$(".add-to-favorites_").addClass('favorite') unless r

  addToFavorites: (e)->
    e.preventDefault()
    e.stopPropagation()
    favorite = new Agreatfirstdate.Models.UserFavorite
    favorite.save favorite_id: @model.id, {
      success: (favorite, response)->
        @$(".add-to-favorites_").addClass('favorite')
        Agreatfirstdate.current_profile.trigger "resetFavorites"
      }

    @

  show: (e)->
    e.preventDefault()
    e.stopPropagation()

    if @me && @me.profileCompleted()
      location.href = "/profiles/#{@model.get('id')}"
    else
      if @me && !@me.profileCompleted()
        header = 'Choose Pillars'
        body = 'Please finish your profile to see profile details pages'
        saveText = 'Settings'
        saveHref = '/me/edit'

      else
        header = 'Free sign up'
        body = "Woh, easy there friend. You can't view profile pages until you sign up. It only takes about five minutes. Did I mention it's free?"
        saveText = 'Sign up'
        saveHref = '/users/sign_up'

      new Agreatfirstdate.Views.Application.Notification
        header: header
        body: body
        allowSave: true
        saveText: saveText
        saveHref: saveHref


  renderPreview: ->
    $(@el).html @previewTemplate(@model.toJSON(false))
    $(@el).removeClass('full')
    @status = 'preview'
    @me.strikes.off 'reset', @renderStrikes, this if @me

    @

  renderFake: ->
    $(@el).html @fakeTemplate()
    @status = 'fake'
    @

  profileLinkText: ->
    'View My Full Profile'

  profileUrl: ->
    if @me
      if @me.get('stripe_customer_token')
        "/profiles/#{ @model.get('id') }"
      else
        "#"
    else
      '/users/sign_up'

  renderFull: ->
    unless @model
      @renderFake()
      return this

    $(@el).html @template(_.extend(@model.toJSON(false), { profileLinkText: @profileLinkText(), profileUrl: @profileUrl() }))

    _.each @model.toJSON(false).pillars, (pillar)->
      @$('.pillars_').append(@pillarTemplate(pillar))
    , @

    $(@el).addClass('full')
    @status = 'full'

    @toggleAddToFavorites(@me.favoriteUsers()) if @me
    @$(".add-to-favorites_").on "click", @addToFavorites

    if @me
      @renderStrikes()
      @me.strikes.on 'reset', @renderStrikes, @
      @$(".strikes_").on "click", @strike
      @$(".show-profile").on 'click', @show unless @me.get('stripe_customer_token')
    else
      @$('.strikes-wrapper_').hide()

    @


  renderStrikes: ->
    strikes = @me.strikes.filter (strike)=> strike.get('striked_id') == @model.id
    @strikesCount = 0
    @strikesCount = strikes[0].attributes.strikes_count if strikes[0]

    striked = Array(@strikesCount+1).join '<img src="/assets/strike-a.png" /> '
    num = 4 - @strikesCount
    strikes_links = while num -= 1
      '<a href="#" class="strike_"><img src="/assets/strike.png" /></a>'
    @$('.strikes_').html(striked + strikes_links.join(' '))

  strike: (e)->
    e.preventDefault()
    e.stopPropagation()
    if @strikesCount < 3
      strike = new Agreatfirstdate.Models.Strike
      data = strike:
        striked_id: @model.id


      strike.save data,
        success: (model, response) =>
          @me.strikes.push model
          @me.strikes.trigger "reset"
          @collection.removeItem @model
