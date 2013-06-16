Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItem extends Backbone.View
  fakeTemplate: JST['search/result_item_fake']
  template: JST['search/result_item']
  pillarTemplate: JST['search/result_item_pillar']
  previewTemplate: JST["search/result_item_preview"]

  className: 'result-item'
  status: 'preview'

  initialize: (options) ->
    @me = Agreatfirstdate.current_profile
    _.bindAll @, "addToFavorites"
  events:
    "click .add-to-favorites_": "addToFavorites"
    "click .strikes_": "strike"

  toggleAddToFavorites: (collection)->
    if @model && @model.id != @me.id
      r = _.isUndefined(collection.find((user)->
         user.id == @model.id
        , @))
      if r
        @$(".add-to-favorites_").css({display: 'inline-block'}).show()
      else
        @$(".add-to-favorites_").hide()

  addToFavorites: (e)->
    e.preventDefault()
    e.stopPropagation()
    favorite = new Agreatfirstdate.Models.UserFavorite
    favorite.save favorite_id: @model.id, {
      success: (favorite, response)->
        @$(".add-to-favorites_").hide()
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

  renderFull: ->
    unless @model
      @renderFake()
      return this

    $(@el).html @template(@model.toJSON(false))

    _.each @model.toJSON(false).pillars, (pillar)->
      @$('.pillars_').append(@pillarTemplate(pillar))
    , @

    $(@el).addClass('full')
    @status = 'full'

    @toggleAddToFavorites(@me.favoriteUsers())
    @$(".add-to-favorites_").on "click", @addToFavorites
    if @me
      @renderStrikes()
      @me.strikes.on 'reset', @renderStrikes, @
    else
      @$('.strikes-wrapper_').hide()

    this

  clickByFavorite: ->

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
        strike:
          striked_id: @model.id

      strike.save
        success: (model, response) ->
          Agreatfirstdate.current_profile.strikes.push model
