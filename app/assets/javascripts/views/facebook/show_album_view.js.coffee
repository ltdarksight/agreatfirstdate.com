Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbumView extends Backbone.View
  template: JST['facebook/show_album']
  photoItemTemplate: JST['facebook/photo_item']

  initialize: ->
    @model.on "change", @render, @
    @model.fetch()

  events:
    "click a.facebook-photo": "uploadFacebookPhoto"
    "click .btn.save": 'handleSave'
    "click .close-btn": 'triggerCloseWindow'

  triggerCloseWindow: (event)->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  handleSave: (event) ->
    if !!$("img.selected", @.$el).length
      $(".modal-body", @.$el).html("Import images")
      $('#new_event_photos').on "ajax:complete", =>
        @modal.hide()
        @.options.parent.trigger "subwindow:close" if @.options.parent

      $('#new_event_photos').submit()
    else
      @modal.hide()
      @.options.parent.trigger "subwindow:close" if @.options.parent


  uploadFacebookPhoto: (e)->
    src_big = $(e.target).data('src_big')
    if $(e.target).hasClass('selected')
      $(e.target).removeClass("selected");
      $("[name='event_photo[remote_image_url][]'][value="+src_big+"]", "#new_event_photo").remove()
      i = $('.photos_count span').html()
      $('.photos_count span').html(--i)

    else
      if(@target == "edit_photo")
        @view = new Agreatfirstdate.Views.User.EditPhotoView(model: @model)
        $("#profile_popup").html(@view.render().el)
        $("#edit_photo").append("<input type='hidden' name='profile[avatars_attributes][][remote_image_url]' value='"+src_big+"'>");
        $('#edit_photo').submit()
      if (true && !$(e.target).hasClass('selected') )
        $(e.target).addClass('selected')
        i = $('.photos_count span').html()
        $('.photos_count span').html(++i)
        $("#new_event_photos").append("<input type='hidden' name='event_photo[remote_image_url][]' value='"+src_big+"'>");


  render: ->
    template = @template
      album: @model

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: template
      el: @el
      view: @
