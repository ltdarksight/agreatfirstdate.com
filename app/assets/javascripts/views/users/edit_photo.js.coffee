Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhoto extends Backbone.View
  template: JST['users/photos/edit']
  
  className: 'edit-photos_'
  el: '#profile_popup'

  initialize: (options) ->
    @model.avatars.on 'add', (collection)->
      @showPreviews(@model.avatars)
    , this

    @model.on('error', (model, errors) ->
      _.each errors['avatars.image'], (error)->
        @$("form .errors_").html error
        @$("form .loader").hide()
    , this)
    
    @render()

  events:
    "change input[type=file]": "update"
    "click a.facebook-import": "openFacebook"
    "click a.instagram-import": "openInstagram"
    'ajax:complete': 'addPhotos'

  openFacebook: ->
    view = new Agreatfirstdate.Views.Facebook.BrowseAlbumsView({model: @model, target: "edit_photo"})
    $("#profile_popup").html(view.$el)
    false
    
  openInstagram: ->
    view = new Agreatfirstdate.Views.Instagram.PhotosView({model: @model, target: "edit_photo"})
    $("#profile_popup").html(view.$el)
    false

  showPreviews: (collection)->
    @$('.avatars, .large_').empty()
    if collection.length > 0
      @$('.avatars').before "<h3>Images</h3>"
    collection.each (avatar, id) ->
      
      view = new Agreatfirstdate.Views.User.Avatars.Preview(
        model: avatar
      )
      
      @$('.avatars').append view.render().el
      # view.showLarge() if 0 == id
    , this
    
  addPhotos: (e, data) ->
    photos = $.parseJSON(data.responseText)
    $('.upload-status').hide()
    _.each photos, (photo) ->
      @model.avatars.add(photo)
    , this
  

  update: (e) ->
    @$("form .loader").show()
    @$("form#edit-photo").submit()

  render: ->
    # @$('form').toggle @model.avatars.length < 3
    # 
    template = @template(
      authenticity_token: $("meta[name=csrf-token]").attr('content')
    )
    
    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Upload Images for Your Profile Picture'
      body: template
      el: @el
      view: this

    @showPreviews(@model.avatars)