Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbumView extends Backbone.View
  template: JST['backbone/facebook/show_album']
  photoItemTemplate: JST['backbone/facebook/photo_item']  
  
  constructor: (options) ->
    super(options)
    @aid = options.aid
    @render()
    
  events:
    "click a.facebook-photo": "uploadFacebookPhoto"
    
  uploadFacebookPhoto: (e)->
    @view = new Agreatfirstdate.Views.User.EditPhotoView(model: @model)
    $("#profile_popup").html(@view.render().el)
    src_big = $(e.target).data('src_big')
    $("#edit_photo").append("<input type='hidden' name='profile[avatars_attributes][][remote_image_url]' value='"+src_big+"'>");
    $('#edit_photo').submit()
  
  render: ->
    $(@el).html(@template())
    $.ajax
      url: '/me/facebook_album/'+@aid
      success: (photos)=>
        $('.facebook-photos').html('') if photos.length > 0
        photo_num = 0
        for photo in photos
          if (photo_num%7 == 0)
            $('.facebook-photos').append('<div class="row"></div>')
          $('.facebook-photos .row:last').append(@photoItemTemplate(photo))
          photo_num++
    
    return this