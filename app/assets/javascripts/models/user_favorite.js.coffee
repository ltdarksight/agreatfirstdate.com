class Agreatfirstdate.Models.UserFavorite extends Backbone.Model
  urlRoot: '/api/favorites'


class Agreatfirstdate.Collections.UserFavoritesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.UserFavorite
  url: '/api/favorites'
