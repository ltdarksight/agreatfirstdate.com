class Agreatfirstdate.Models.UserFavorite extends Backbone.Model
  urlRoot: '/api/favorites'

  defaults:
    avatar:
      image:
        thumb:
          url: "/assets/defaults/avatar/thumb.jpg"
        preview:
          url: "/assets/defaults/avatar/preview.jpg"
        search_thumb:
          url: "/assets/defaults/avatar/search_thumb.png"


class Agreatfirstdate.Collections.UserFavoritesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.UserFavorite
  url: '/api/favorites'
