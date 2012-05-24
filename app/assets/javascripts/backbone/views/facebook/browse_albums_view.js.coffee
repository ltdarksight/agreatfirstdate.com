Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  template: JST['backbone/facebook/browse_albums']
  albumItemTemplate: JST['backbone/facebook/album_item']
  photoItemTemplate: JST['backbone/facebook/photo_item']

  constructor: (options) ->
    super(options)
    @render()
    
  events:
    "click a.facebook_album": "show_facebook_album"
    "click a.facebook_photo": "upload_facebook_photo"

  show_facebook_album: (e)->
    aid = $(e.target).data('aid')
    $.ajax
      url: '/me/facebook_album/'+aid
      success: (photos)=>
        $('.albums').html('')
        for photo in photos
          $('.albums').append(@photoItemTemplate(photo))
          
  upload_facebook_photo: (e)->
    $.ajax
      url: '/me/upload_facebook_avatar'
      type: 'post'
      data:
        pid: $(e.target).data('pid')
      success: (data)=>
        $(@el).dialog('close')

  render: ->
    $(@el).html(@template())
    $.ajax
      url: '/me/facebook_albums'
      success: (albums)=>
        $('.albums').html('') if albums.length > 0
        for album in albums
          $('.albums').append(@albumItemTemplate(album))
    return this
