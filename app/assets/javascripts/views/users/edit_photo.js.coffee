Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhoto extends Backbone.View
  template: JST['users/photos/edit']

  className: 'edit-photos_'
  el: '#profile_popup'

  initialize: (options) ->
    @.on "subwindow:close", @handleCloseSubwindow, @
    @model.avatars.on 'add', (collection)->
      @showPreviews(@model.avatars)
      @setCropAvatar(@model.avatars.last())
    , @

    @model.avatars.on 'reset', (collection)->
      @render
    , @

    @model.on('error', (model, errors) ->
      _.each errors['avatars.image'], (error)->
        @$("form .errors_").html error
        @$("form .loader").hide()
    , @)
    @imageCrop = new Agreatfirstdate.Views.User.Avatars.Crop
    @render()

  events:
    "change input[type=file]": "update"
    "click a.facebook-import": "openFacebook"
    "click a.instagram-import": "openInstagram"
    'ajax:success': 'addPhotos'
    'ajax:error': 'showErrors'
    'ajax:complete': 'hideLoader'
    'click .crop-image': 'crop'
    'click .btn.save' : 'handleSave'

  handleSave: ->
    @model.fetch()
    @modal.hide()

  handleCloseSubwindow: ->
    @.$el.css
      opacity: 1

  destroyAvatar: (avatarPreviewView)->
    avatarPreviewView.$el.css
      opacity: .4
    $('a',  avatarPreviewView.$el).remove()
    avatarPreviewView.model.destroy
      wait: true
      success: (model, response) =>
        if avatarPreviewView.model == @imageCrop.model
          @render()
        avatarPreviewView.$el.remove()

  crop: (e)->
    @imageCrop.crop(e)

  openFacebook: (event)->
    @.$el.css
      opacity: .1

    view = new Agreatfirstdate.Views.Facebook.BrowseAlbumsView
      parent: @
      model: @model
      target: 'edit_photo'

  openInstagram: (event)->
    @.$el.css
      opacity: .1

    view = new Agreatfirstdate.Views.Instagram.PhotosView
      parent: @
      model: @model
      target: 'edit_photo'


  showPreviews: (collection)->
    @$('.avatars, .large_').empty()
    @$("h3", ".avatars_wrapper").remove()
    if collection.length > 0
      @$('.avatars').before "<h3>Images</h3>"
    collection.each (avatar, id) ->
      view = new Agreatfirstdate.Views.User.Avatars.Preview(
        model: avatar,
        cropView: @imageCrop,
        parentView: @
      )

      @$('.avatars').append view.render().el

    , @


  hideLoader: ->
    @$("form .loader").hide()

  showErrors: (e, response) ->
    @$(".errors_").empty()
    response_errors = $.parseJSON(response.responseText);
    errors = []
    for key, error of response_errors
      errors.push(error)
    @$(".errors_").html(errors.join(", "))

  addPhotos: (e, data) ->
    @$(".errors_").empty()
    try
      photos = $.parseJSON(data)
    catch error
      photos = data

    $('.upload-status').hide()
    _.each photos, (photo) ->
      @model.avatars.add(photo)
    , @


  update: (e) ->
    @$("form .loader").show()
    @$("form#edit-photo").submit()

  setCropAvatar: (avatar)->
    if avatar
      @imageCrop.setElement($(".crop-wrapper"))
      @imageCrop.setAvatar(avatar)

  render: (render_options) ->
    template = @template(
      authenticity_token: $("meta[name=csrf-token]").attr('content')
    )

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Upload Images for Your Profile Picture'
      body: template
      el: @el
      view: @

    @showPreviews(@model.avatars)
    @setCropAvatar(@model.avatars.first())
