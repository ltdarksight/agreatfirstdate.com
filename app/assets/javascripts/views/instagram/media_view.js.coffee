Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.MediaView extends Backbone.View
  el: $("#instagram_popup")
  template: JST['instagram/media']
  photoItemTemplate: JST['instagram/item']

  events:
    'click .row-fluid': 'uploadInstagramPhoto'
    "hidden": 'handleCloseSubwindow'
    "click .btn.save": 'handleSave'

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "appendRender"
    @target = @.options.target
    @media = new Agreatfirstdate.Collections.InstagramMedia
    @media.fetch
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

  handleSave: (event)->
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
    image_data = $($(e.target).closest("a")).data()
    console.log image_data
    src_big = image_data['src_big']

    if $(e.target).hasClass('selected')
      $(e.target).removeClass("selected");
      $('[name^="instagram_photos['+image_data['id']+']"]').remove()
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
        if (image_data['type'] == 'video')
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][remote_image_url]' value='"+src_big+"'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][link]' value='"+image_data["link"]+"'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][video_url]' value='"+image_data["video_url"]+"'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][source]' value='instagram'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][kind]' value='video'>");

        else
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][remote_image_url]' value='"+src_big+"'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][source]' value='instagram'>");
          $('#new_event_photos').append("<input type='hidden' name='instagram_photos["+image_data['id']+"][kind]' value='photo'>");


  appendRender: (collection, response) ->
    @.$(".loader").text("")
    collection.each (item)=>
      @.$(".row-fluid").append(@photoItemTemplate(item.toJSON()))

  render: ->
    template = @template
      photos: @media

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'aGreatFirstDate - Profile'
      body: template
      el: @el
      view: @

    @.infiniScroll = new Backbone.InfiniScroll @media,
      target: @$(".row-fluid")
      pageSize: 20
      param: 'max_id'
      success: @appendRender
      onFetch: =>
        @.$(".loader").text("loading ...")


    @
