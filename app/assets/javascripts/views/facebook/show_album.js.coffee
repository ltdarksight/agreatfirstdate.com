Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbum extends Backbone.View
  template: JST['facebook/show_album']
  photoItemTemplate: JST['facebook/photo_item']

  initialize: (options) ->
    _.bindAll this, "handleCloseSubwindow"
    @render()

    @eventPhotos = options.eventPhotos
    @parent = options.parent

    @selectedPhotos = options.selectedPhotos

    @model.on "change", @renderItems, this
    @model.fetch()

  events:
    "click .btn.save": 'save'
    "hidden": 'handleCloseSubwindow'

  handleCloseSubwindow: (event)->
    @options.parent.trigger "subwindow:close" if @options.parent

  save: (event) ->
    @parent.parent.parent.uploadSelectedPhotos(@selectedPhotos)

    @modal.hide()
    false

  renderItems: =>
    _.each @model.get("photos"), (photo, i) ->
      item = new Agreatfirstdate.Views.Facebook.PhotoItem
        model: photo
        selectedPhotos: @selectedPhotos
        parent: this
      $(@el).find('.facebook-photos').append item.render().el
    , this

  render: ->
    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Album ' + @model.get('name')
      body: @template(album: @model)
      el: @el
      view: this
