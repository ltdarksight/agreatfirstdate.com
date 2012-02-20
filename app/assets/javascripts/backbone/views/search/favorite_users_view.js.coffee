Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.FavoriteUsersView extends Backbone.View
  initialize: (options)->
    @me = options.me
    @collection = @me.favoriteUsers
    super

  addAll: () =>
    if (@collection.length > 0)
      @collection.each(@addOne)

  addOne: (item) =>
    view = new Agreatfirstdate.Views.Search.FavoriteUserView({model: item, me: @me})
    $(@el).append(view.render().el)

  render: ->
    $(@el).empty()
    @addAll()
    return this
