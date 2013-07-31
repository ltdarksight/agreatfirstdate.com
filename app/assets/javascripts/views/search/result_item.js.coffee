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
    @me  = Agreatfirstdate.currentProfile
    _.bindAll @, "addToFavorites"
    _.bindAll @, "strike"

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
    if @me && @me.profileCompleted && @me.get('card_verified?')
      location.href = "/profiles/#{@model.get('id')}"
    else
      button = if @me
        if !@me.profileCompleted
          "Choose Pillars": ->
            location.href = '/me#/pillars/choose'
        else if !@me.get('card_verified?')
          "Complete Profile": ->
            location.href = '/me/edit'
      else
        "Free sign up": ->
          location.href = '/users/sign_up'

      $('#show_restriction_popup').dialog({
        title: "aGreatFirstDate",
        height: 200,
        width: 640,
        resizable: false,
        draggable: false,
        modal: true,
        buttons: $.extend(button, {
          "Cancel": ->
            $(this).dialog('close')
        })
      })


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
      "/profiles/"+@model.get('id')
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
    else
      @$('.strikes-wrapper_').hide()

    @


  renderStrikes: ->
    strikes = @me.strikes.filter (strike)=> strike.get('striked_id') == @model.id
    @strikesCount = strikes.length
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
