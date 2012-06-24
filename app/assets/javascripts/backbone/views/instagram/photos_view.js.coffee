Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.PhotosView extends Backbone.View
  template: JST['backbone/instagram/photos']
  photoItemTemplate: JST['backbone/instagram/photo']

  constructor: (options) ->
    super(options)
    @target = options.target
    _.bindAll(this, 'loadMore')
    @render()
    
  events:
    'click a.instagram-photo': 'uploadInstagramPhoto'

  uploadInstagramPhoto: (e)->
    src_big = $(e.target).data('src_big')
    if(@target == "edit_photo")
      @view = new Agreatfirstdate.Views.User.EditPhotoView(model: @model)
      $("#profile_popup").html(@view.render().el)
      $("#edit_photo").append("<input type='hidden' name='profile[avatars_attributes][][remote_image_url]' value='"+src_big+"'>");
      $('#edit_photo').submit()
    if(@target == "event_photos_new" && !$(e.target).hasClass('selected'))
      $(e.target).addClass('selected')
      i = $('.photos_count span').html()
      $('.photos_count span').html(++i)
      $('#new_event_photo').append("<input type='hidden' name='event_photo[remote_image_url][]' value='"+src_big+"'>");
      $('#new_event_photo').submit()
  
  loadMore: (id) =>
    last_id = $('.instagram-photos').data('last-id')
    if last_id == 0 || $(".ajax-loader").length > 0
      return false
    $('.instagram-photos').append('<div class="ajax-loader"><img src="/assets/ajax-loader.gif" /></div>')
    $.ajax
      url: '/me/instagram_photos'
      data: { max_id: last_id }
      success: (albums)=>
        $(".ajax-loader").remove()
        for album in albums
          if (@album_num%4 == 0)
            $('.instagram-photos').append('<div class="row"></div>')
          $('.instagram-photos .row:last').append(@photoItemTemplate(album))
          @album_num++
        if album
          $('.instagram-photos').data('last-id', album.id)
        else
          $('.instagram-photos').data('last-id', 0)
  
  render: ->
    $(@el).html(@template())
    
    that = this
    
    $.ajax
      url: '/me/instagram_photos'
      success: (albums) =>
        if albums.length > 0
          $('.instagram-photos').html('')          
        @album_num = 0
        for album in albums
          if (@album_num%4 == 0)
            $('.instagram-photos').append('<div class="row"></div>')
          $('.instagram-photos .row:last').append(@photoItemTemplate(album))          
          @album_num++
        if albums.length > 0          
          $('.instagram-photos').data('last-id', album.id)
          $('.instagram-photos').scroll ->
            that.loadMore($('.instagram-photos').data('last-id')) if $('.instagram-photos').scrollTop() is $('.instagram-photos').prop('scrollHeight') - $('.instagram-photos').height()
    return this
