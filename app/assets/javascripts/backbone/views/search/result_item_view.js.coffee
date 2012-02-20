Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItemView extends Backbone.View
  template: JST["backbone/search/result_item"]

  initialize: (options) ->
    super
    @me = options.me
    @me.favoriteUsers.on 'reset', @toggleAddToFavorites, this

  events:
    "click .add-to-favorites_" : "addToFavorites"

  toggleAddToFavorites: (collection)->
    @$(".add-to-favorites_").toggle _.isUndefined(collection.find((user)->
      user.id == @model.id
    , this))

  addToFavorites: (e)->
    e.preventDefault()
    @me.save('favorites_attributes', [{favorite_id: @model.id}], {
      success: (user, response)->
        user.favoriteUsers.reset response.favorite_users
    });

  show: ->
    location.hash = "#/profile/#{@model.get('id')}"

  render: ->
    $(@el).html @template(@model.toJSON())
    @toggleAddToFavorites(@me.favoriteUsers)
    return this
