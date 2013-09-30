Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.AlbumItem extends Backbone.View
  template: JST['facebook/album_item']
  tagName: 'li'
  className: 'album-item'

  initialize: (options) ->
    @parent = options.parent
    @eventPhotos = options.eventPhotos
    @selectedPhotos = options.selectedPhotos

  events:
    'click a.album': 'showAlbum'

  render: ->
    $(@el).html @template(album: @model)
    this

  showAlbum: (e) ->
    view = new Agreatfirstdate.Views.Facebook.ShowAlbum
      parent: this
      model: @model
      el: @parent.el
      eventPhotos: @eventPhotos
      selectedPhotos: @selectedPhotos
    false