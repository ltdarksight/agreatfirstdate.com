Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.ShowAlbum extends Backbone.View
  template: JST['facebook/show_album']
  photoItemTemplate: JST['facebook/photo_item']

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    @target = @.options.parent.options.target
    @model.on "change", @render, @
    @model.fetch()

  events:
    "click a.facebook-photo": "uploadFacebookPhoto"
    "click .btn.save": 'save'
    "hidden": 'handleCloseSubwindow'

  handleCloseSubwindow: (event)->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  save: (event) ->
    if (@target == "edit_photo")
      @modal.hide()
      @.options.parent.trigger "subwindow:close" if @.options.parent

    else
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
        $("#edit-photo").append("<input type='hidden' name='avatars[][remote_image_url]' value='"+src_big+"'>");
        $('#edit-photo').on "ajax:error", (e, response)=>
          response_errors = $.parseJSON(response.responseText);
          errors = []
          for key, error of response_errors
            errors.push(error)
          $(".album_error").html(errors.join(", "))

        $('#edit-photo').submit()

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
