Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  el: $("#facebook_albums_popup")
  template: JST['facebook/browse_albums']
  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "hide"

    @albums = new Agreatfirstdate.Collections.FacebookAlbums
    @albums.on "reset", @render, @
    @albums.fetch
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
              @albums.fetch({})

    @.on "subwindow:close", @handleCloseSubwindow, @


  handleCloseSubwindow: ->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  events:
    "click a.link-to-album": "showFacebookAlbum"
    "hidden": 'handleCloseSubwindow'


  showFacebookAlbum: (e)->
    aid = $(e.target).data('aid')
    @album = @albums.find (album)=> album.get("aid") == aid

    view = new Agreatfirstdate.Views.Facebook.ShowAlbumView
      parent: @
      model: @album
      el: @el

  hide: ->
    @modal.hide()

  render: ->
    template = @template
      albums: @albums

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: template
      el: @el
      view: @
      allowSave: false
