Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.PhotosView extends Backbone.View
  el: $("#instagram_popup")
  template: JST['instagram/photos']
  photoItemTemplate: JST['instagram/photo']

  events:
    'click .row-fluid': 'uploadInstagramPhoto'
    "hidden": 'handleCloseSubwindow'
    "click .btn.save": 'handleSave'

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "appendRender"
    @target = @.options.target
    @photos = new Agreatfirstdate.Collections.InstagramPhotos
    @photos.fetch
      success: (collection, response) =>
        @render()
      error: (model, response) ->
        errors = $.parseJSON(response.responseText)
        if errors['message'] == 'not_connect'
          new Agreatfirstdate.Views.InstagramConnectView
            url: errors['location']
            el: $("#popup-instagram-connect")

  handleSave: (event)->
    if !!$("img.selected", @.$el).length
      @.$(".modal-body").html("Import images")
      @.$("a.btn, a.close-btn").hide()
      $('#new_event_photos').on "ajax:complete", =>
        @.$("a.btn, a.close-btn").show()
        @.$el.modal('hide')
        @.options.parent.trigger "subwindow:close" if @.options.parent

      $('#new_event_photos').submit()
    else
      @.$el.modal('hide')
      @.options.parent.trigger "subwindow:close" if @.options.parent


  handleCloseSubwindow: ->
    @.options.parent.trigger "subwindow:close" if @.options.parent

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
      $('#new_event_photos').append("<input type='hidden' name='event_photo[remote_image_url][]' value='"+src_big+"'>");
      #$('#new_event_photos').submit()

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

  appendRender: (collection, response) ->
    @.$(".loader").text("")
    collection.each (item)=>
      @.$(".row-fluid").append("<div class='photo-item span2'><a><img style='max-height: 65px;' src='"+item.thumbnail().url+"'/></a></div>")

  render: ->
    template = @template
      photos: @photos

    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: template
      el: @el
      view: @

    @.infiniScroll = new Backbone.InfiniScroll @photos,
      target: @$(".row-fluid")
      pageSize: 20
      param: 'max_id'
      success: @appendRender
      onFetch: =>
        @.$(".loader").text("loading ...")


    @
    #$.ajax
    #  url: '/me/instagram_photos'
    #  success: (albums) =>
    #    if albums.length > 0
    #      $('.instagram-photos').html('')
    #    @album_num = 0
    #    for album in albums
    #      if (@album_num%4 == 0)
    #        $('.instagram-photos').append('<div class="row"></div>')
    #      $('.instagram-photos .row:last').append(@photoItemTemplate(album))
    #      @album_num++
    #    if albums.length > 0
    #      $('.instagram-photos').data('last-id', album.id)
    #      $('.instagram-photos').scroll ->
    #        that.loadMore($('.instagram-photos').data('last-id')) if $('.instagram-photos').scrollTop() is $('.instagram-photos').prop('scrollHeight') - $('.instagram-photos').height()
