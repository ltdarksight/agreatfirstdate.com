Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.PhotosView extends Backbone.View
  el: $("#instagram_popup")
  template: JST['instagram/photos']
  photoItemTemplate: JST['instagram/photo']

  events:
    'click .row-fluid': 'uploadInstagramPhoto'
    "hidden": 'handleCloseSubwindow'
    "click .btn.save": 'save'

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "appendRender"
    @target = @.options.target
    @photos = new Agreatfirstdate.Collections.InstagramPhotos
    @photos.fetch
      data:
        return_to: window.location.href
      success: (collection, response) =>
        @render()
      error: (model, response) ->
        errors = $.parseJSON(response.responseText)
        if errors['message'] == 'not_connect'
          new Agreatfirstdate.Views.InstagramConnectView
            url: errors['location']
            el: $("#popup-instagram-connect")

  save: (event)->
    if (@target == "edit_photo")
      @modal.hide()
      @.options.parent.trigger "subwindow:close" if @.options.parent

    else
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
    src_big = $($(e.target).closest("a")).data('src_big')
    if $(e.target).hasClass('selected')
      $(e.target).removeClass("selected");
      $("[name='event_photo[remote_image_url][]'][value="+src_big+"]", "#new_event_photo").remove()
      i = $('.photos_count span:first').html()
      $('.photos_count span:first').html(--i)

    else
      if(@target == "edit_photo")
        $(e.target).addClass('selected')
        i = $('.photos_count span:first').html()
        $('.photos_count span:first').html(++i)

        $("#edit-photo").append("<input type='hidden' name='avatars[][remote_image_url]' value='"+src_big+"'>");
        $('#edit-photo').on "ajax:error", (e, response)=>
          response_errors = $.parseJSON(response.responseText);
          errors = []
          for key, error of response_errors
            errors.push(error)
          $(".instagram_error").html(errors.join(", "))
        $('#edit-photo').on "ajax:success", ->
          $(".instagram_error").html("")
        $('#edit-photo').on "ajax:beforeSend", ->
          $(".modal-footer", "#instagram_popup").hide()
          $(".instagram_error").html("Uploading image...")
        $('#edit-photo').on "ajax:complete", ->
          $(".modal-footer", "#instagram_popup").show()

        $('#edit-photo').submit()
      if(@target == "event_photos_new" && !$(e.target).hasClass('selected'))
        $(e.target).addClass('selected')
        i = $('.photos_count span:first').html()
        $('.photos_count span:first').html(++i)
        $('#new_event_photos').append("<input type='hidden' name='event_photo[remote_image_url][]' value='"+src_big+"'>");


  appendRender: (collection, response) ->
    @.$(".loader").text("")
    collection.each (item)=>
      @.$(".row-fluid").append(@photoItemTemplate(item.toJSON()))

  render: ->
    template = @template
      photos: @photos

    @modal = new Agreatfirstdate.Views.Application.Modal
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
