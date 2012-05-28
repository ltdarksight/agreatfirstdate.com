Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  template: JST['backbone/facebook/browse_albums']
  albumItemTemplate: JST['backbone/facebook/album_item']

  constructor: (options) ->
    super(options)
    @render()
    
  events:
    "click a.facebook_album": "show_facebook_album"

  show_facebook_album: (e)->
    aid = $(e.target).data('aid')
    view = new Agreatfirstdate.Views.Facebook.ShowAlbumView({aid: aid, model: @model})
    $('#profile_popup').html(view.$el)

  render: ->
    $(@el).html(@template())
    $.ajax
      url: '/me/facebook_albums'
      success: (albums)=>
        $('.albums').html('') if albums.length > 0
        for album in albums
          $('.albums').append(@albumItemTemplate(album))
    return this
