Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbums extends Backbone.View
  el: $("#facebook_albums_popup")
  template: JST['facebook/browse_albums']

  initialize: (options) ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "hide"

    @eventPhotos = options.eventPhotos
    @parent = options.parent

    @collection = new Agreatfirstdate.Collections.FacebookAlbums
    @collection.on "reset", @renderItems, this
    @collection.fetch
      error: (model, response) =>
        errors = $.parseJSON(response.responseText)
        if errors['message'] == 'not_connect'
          new Agreatfirstdate.Views.Facebook.ConnectView
            url: errors['location']
            el: $("#popup-facebook-connect")
            afterFailLogin: =>
              $("#facebook_albums_popup").modal("hide")
              @.handleCloseSubwindow()
            afterLogin: =>
              @collection.fetch()

    @on "subwindow:close", @handleCloseSubwindow, this
    @render()


  handleCloseSubwindow: ->
    @parent.trigger "subwindow:close" if @parent

  events:
    "hidden": 'handleCloseSubwindow'

  hide: ->
    @modal.hide()

  renderItems: ->
    @$('.loader').hide()
    @collection.each (model) ->
      item = new Agreatfirstdate.Views.Facebook.AlbumItem
        model: model
        parent: this
        eventPhotos: @eventPhotos

      $(@el).find('.facebook-albums').append item.render().el
    , this

  render: ->
    template = @template
      albums: @collection

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Facebook Albums'
      body: template
      el: @el
      view: @
      allowSave: false
