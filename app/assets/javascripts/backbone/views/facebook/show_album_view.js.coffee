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
    $.ajax
      url: '/me/upload_facebook_avatar'
      type: 'post'
      data:
        pid: $(e.target).data('pid')
      success: (data)=>
        $("#profile_popup").dialog('close')
  
  render: ->
    $(@el).html(@template())
    $.ajax
      url: '/me/facebook_album/'+@aid
      success: (photos)=>
        for photo in photos
          $('.photos').append(@photoItemTemplate(photo))
    
    return this