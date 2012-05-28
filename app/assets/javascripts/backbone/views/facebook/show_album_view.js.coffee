Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbumView extends Backbone.View
  template: JST['backbone/facebook/show_album']
  photoItemTemplate: JST['backbone/facebook/photo_item']  
  
  constructor: (options) ->
    super(options)
    @aid = options.aid
    @render()
    
  events:
    "click a.facebook_photo": "upload_facebook_photo"
    
  upload_facebook_photo: (e)->
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
        for photo in photos
          $('.photos').append(@photoItemTemplate(photo))
    
    return this