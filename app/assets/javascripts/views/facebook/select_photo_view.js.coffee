Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.SelectPhotoView extends Backbone.View
  template: JST["facebook/select_photo"]

  constructor: (options) ->
    super(options)

  render: ->
    $(@el).html(@template())
    return this
