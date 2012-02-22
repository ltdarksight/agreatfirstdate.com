Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItemView extends Backbone.View
  template: JST["backbone/search/result_item"]
  pillarTemplate: JST["backbone/search/result_item_pillar"]

  initialize: (options) ->
    super
    if @me = options.me
      @me.favoriteUsers.on 'reset', @toggleAddToFavorites, this

  events:
    "click .add-to-favorites_": "addToFavorites"
    "click .show_": "show"

  toggleAddToFavorites: (collection)->
    @$(".add-to-favorites_").toggle @model.id != @me.id && _.isUndefined(collection.find((user)->
      user.id == @model.id
    , this))

  addToFavorites: (e)->
    e.preventDefault()
    @me.save('favorites_attributes', [{favorite_id: @model.id}], {
      success: (user, response)->
        user.favoriteUsers.reset response.favorite_users
    });

  show: (e)->
    e.preventDefault()
    e.stopPropagation()
    location.href = "/profiles/#{@model.get('id')}" if @me

  render: ->
    $(@el).html @template(@model.toJSON(false))
    _.each @model.toJSON(false).pillars, (pillar)->
      @$('.pillars_').append(@pillarTemplate(pillar))
    , this
    @toggleAddToFavorites(@me.favoriteUsers) if @me
    return this
