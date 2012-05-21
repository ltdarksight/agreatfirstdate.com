Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  template: JST["backbone/facebook/browse_albums"]

  constructor: (options) ->
    super(options)
    @render()

  render: ->
    $(@el).html(@template())
    @model.sync 'facebook_albums', @model, success: (user)=>
      alert(1)
    return this
