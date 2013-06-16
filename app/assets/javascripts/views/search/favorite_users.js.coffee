Agreatfirstdate.Views.Search ||= {}
class Agreatfirstdate.Views.Search.FavoriteUser extends Backbone.View
  template: JST['search/favorite_user']
  initialize: ->
    @render()
  events:
    "click .destroy_" : 'removeFromFavorites'

  removeFromFavorites: ->

  render: ->
    @$el.html @template(@model.toJSON())
    @

class Agreatfirstdate.Views.Search.FavoriteUsers extends Backbone.View
  el: '#favorite_users .favorite-users_'


  initialize: (options)->

  render: ->
    @$el.empty()

    @collection.each (item) ->
      if item.get("avatar")
        v = new Agreatfirstdate.Views.Search.FavoriteUser model: item
        @$el.append(v.$el)
    ,@



    $('.frame', '.favorite-users_').hover (->
      $(".destroy_", $(this)).stop(true).fadeIn();
      ), ->
        $(".destroy_", $(this)).stop(true).fadeOut();

    @
