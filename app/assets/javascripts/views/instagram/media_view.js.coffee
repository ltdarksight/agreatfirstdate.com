Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.MediaView extends Backbone.View
  el: $("#instagram_popup")
  template: JST['instagram/media']
  photoItemTemplate: JST['instagram/item']

  events:
    'hidden': 'handleCloseSubwindow'
    'click .btn.save': 'save'

  initialize: (options) ->
    @target = options.target
    @eventPhotos = options.eventPhotos
    @collection = new Agreatfirstdate.Collections.InstagramMedia
    @selectedPhotos = new Agreatfirstdate.Collections.EventPhotos
    @render()
    @collection.on('reset', @renderResults, this)
    @collection.on('error', @renderInstagramConnect, this)
    @collection.fetch()

  renderInstagramConnect: (model, response) ->
    new Agreatfirstdate.Views.InstagramConnectView

  renderResults: (event) ->
    @collection.each (model) ->
      if model.get('type') == 'image'
        item = new Agreatfirstdate.Views.Instagram.Photo
          model: model
          parent: this
          selectedPhotos: @selectedPhotos
      if model.get('type') == 'video'
        item = new Agreatfirstdate.Views.Instagram.Video
          model: model
          parent: this
          selectedPhotos: @selectedPhotos

      $(@el).find('.instagram-photos .row-fluid').append item.render().el
    , this

  save: (event) ->


    @selectedPhotos.each (eventPhoto) =>
      data =
        remote_image_url: eventPhoto.get('url')
        remote_video_url: eventPhoto.get('videoUrl')
        kind: 'video'
      $.ajax
        type: 'POST',
        url: Routes.api_event_photos_path()
        data:
          event_photo: data
        success: (response) =>
          @eventPhotos.add response

  handleCloseSubwindow: ->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  uploadInstagramPhoto: (e)->
    image_data = $($(e.target).closest("a")).data()
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
    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Import from instagram'
      body: @template()
      el: @el
      view: @

    # @.infiniScroll = new Backbone.InfiniScroll @collection,
    #   target: @$(".row-fluid")
    #   pageSize: 20
    #   param: 'max_id'
    #   success: @appendRender
    #   onFetch: =>
    #     @.$(".loader").text("loading ...")


    @
