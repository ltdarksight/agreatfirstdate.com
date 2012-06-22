Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.PhotosView extends Backbone.View
  template: JST['backbone/instagram/photos']
  photoItemTemplate: JST['backbone/instagram/photo']

  constructor: (options) ->
    super(options)
    @target = options.target
    @render()
    
  events:
    "click a.link-to-album": "showInstagramAlbum"

  showInstagramAlbum: (e)->
    aid = $(e.target).data('aid')
    # view = new Agreatfirstdate.Views.Instagram.ShowAlbumView({aid: aid, model: @model, target: @target})
    #     $('#profile_popup').html(view.$el)

  render: ->
    $(@el).html(@template())
    $.ajax
      url: '/me/instagram_photos'
      success: (albums)=>
        $('.instagram-photos').html('') if albums.length > 0
        album_num = 0
        for album in albums
          if (album_num%4 == 0)
            $('.instagram-photos').append('<div class="row"></div>')
          $('.instagram-photos .row:last').append(@photoItemTemplate(album))
          album_num++
    return this
