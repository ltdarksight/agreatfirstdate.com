Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  template: JST["backbone/facebook/browse_albums"]

  constructor: (options) ->
    super(options)
    @render()

  render: ->
    $(@el).html(@template())
    return this
