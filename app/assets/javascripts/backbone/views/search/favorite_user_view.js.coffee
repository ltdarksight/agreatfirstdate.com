Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.FavoriteUserView extends Backbone.View
  template: JST["backbone/search/favorite_user"]

  initialize: (options)->
    @me = options.me
    super

  events:
    'click .destroy_': 'destroy'

  destroy: (e)->
    favorite = _(@me.toJSON().favorites).find (favorite)->
      favorite.favorite_id = @model.id
    , this
    @me.save('favorites_attributes', [{id: favorite.id, _destroy: true}], {
      success: (user, response)->
        user.favoriteUsers.reset response.favorite_users
    });
    return false

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
