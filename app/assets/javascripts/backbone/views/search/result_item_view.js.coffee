Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItemView extends Backbone.View
  fakeTemplate: JST["backbone/search/result_item_fake"]
  previewTemplate: JST["backbone/search/result_item_preview"]
  fullTemplate: JST["backbone/search/result_item_full"]
  pillarTemplate: JST["backbone/search/result_item_pillar"]

  className: 'result-item'
  status: 'preview'

  initialize: (options) ->
    super
    if @me = options.me
      @me.favoriteUsers.on 'reset', @toggleAddToFavorites, this


  events:
    "click .add-to-favorites_": "addToFavorites"
    "click .show_": "show"
    "click .strike_": "strike"

  toggleAddToFavorites: (collection)->
    if @model
      @$(".add-to-favorites_").toggle @model.id != @me.id && _.isUndefined(collection.find((user)->
        user.id == @model.id
      , this))

  addToFavorites: (e)->
    e.preventDefault()
    e.stopPropagation()
    @me.save('favorites_attributes', [{favorite_id: @model.id}], {
      success: (user, response)=>
        @me.unset('favorites_attributes', silent: true)
        user.favoriteUsers.reset response.favorite_users
    });

  show: (e)->
    e.preventDefault()
    e.stopPropagation()
    if @me && @me.profileCompleted
      location.href = "/profiles/#{@model.get('id')}"
    else
      $('#show_restriction_popup').dialog({
        title: "aGreatFirstDate",
        height: 200,
        width: 640,
        resizable: false,
        draggable: false,
        modal: true,
        buttons: {
          "Finish": ->
            location.href = if @me then '/me' else '/users/sign_up'
          "Cancel": ->
            $(this).dialog('close')
        }
      })


  renderPreview: ->
    $(@el).html @previewTemplate(@model.toJSON(false))
    $(@el).removeClass('full')
    @status = 'preview'
    @me.strikes.off 'reset', @renderStrikes, this

    return this

  renderFake: ->
    $(@el).html @fakeTemplate()
    @status = 'fake'
    return this

  renderFull: ->
    unless @model
      @renderFake()
      console.log 'not loaded'
      return this

    @me.strikes.on 'reset', @renderStrikes, this

    $(@el).html @fullTemplate(@model.toJSON(false))
    _.each @model.toJSON(false).pillars, (pillar)->
      @$('.pillars_').append(@pillarTemplate(pillar))
    , this
    $(@el).addClass('full')
    @status = 'full'
    @toggleAddToFavorites(@me.favoriteUsers) if @me && @me.profileCompleted

    @renderStrikes()
    return this

  renderStrikes: ->
    strikes = @me.strikes.filter (strike)=> strike.get('striked_id') == @model.id
    @strikesCount = strikes.length
    @$('.strikes_').html(Array(@strikesCount+1).join 'X')
    @$('.strike_').hide() if @strikesCount >= 3

  strike: (e)->
    e.preventDefault()
    e.stopPropagation()
    if @strikesCount < 3
      @me.save('strikes_attributes', [{striked_id: @model.id}], {
        success: (user, response)=>
          @me.unset('strikes_attributes', silent: true)
          user.strikes.reset response.strikes
      });