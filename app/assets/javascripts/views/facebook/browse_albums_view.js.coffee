Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.BrowseAlbumsView extends Backbone.View
  template: JST['facebook/browse_albums']
  albumItemTemplate: JST['facebook/album_item']

  constructor: (options) ->
    super(options)
    @target = options.target
    @render()

  events:
    "click a.link-to-album": "showFacebookAlbum"

  showFacebookAlbum: (e)->
    aid = $(e.target).data('aid')
    view = new Agreatfirstdate.Views.Facebook.ShowAlbumView({aid: aid, model: @model, target: @target})
    $('#profile_popup').html(view.$el)

  render: ->
    template = @template()

    $.ajax
      url: '/me/facebook_albums'
      success: (albums)=>
        $('.facebook-albums').html('') if albums.length > 0
        album_num = 0
        for album in albums
          if (album_num%4 == 0)
            $('.facebook-albums').append('<div class="row"></div>')
          $('.facebook-albums .row:last').append(@albumItemTemplate(album))
          album_num++

    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: template
      el: @el
      view: @
