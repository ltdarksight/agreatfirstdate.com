Agreatfirstdate.Views.Search ||= {}
class Agreatfirstdate.Views.Search.FavoriteUser extends Backbone.View
  template: JST['search/favorite_user']
  initialize: ->
    @render()
  events:
    "click .destroy_" : 'removeFromFavorites'

  removeFromFavorites: ->

  render: ->
    @$el.html @template @model
    @

class Agreatfirstdate.Views.Search.FavoriteUsers extends Backbone.View
  el: '#favorite_users .favorite-users_'


  initialize: (options)->

  render: ->
    html = []
    _.each @collection, (item, i) =>
      v = new Agreatfirstdate.Views.Search.FavoriteUser model: item
      @$el.append(v.$el)



    $('.frame', '.favorite-users_').hover (->
      $(".destroy_", $(this)).stop(true).fadeIn();
      ), ->
        $(".destroy_", $(this)).stop(true).fadeOut();

    @
