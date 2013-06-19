Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.PhotosView extends Backbone.View
  el: $("#instagram_popup")
  template: JST['instagram/photos']
  photoItemTemplate: JST['instagram/photo']

  events:
    'click .row-fluid': 'uploadInstagramPhoto'
    "hidden": 'handleCloseSubwindow'
    "click .btn.save": 'handleSave'

  initialize: ->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "appendRender"
    @target = @.options.target
    @photos = new Agreatfirstdate.Collections.InstagramPhotos
    @photos.fetch
      success: (collection, response) =>
        @render()
      error: (model, response) ->
        errors = $.parseJSON(response.responseText)
        if errors['message'] == 'not_connect'
          new Agreatfirstdate.Views.InstagramConnectView
            url: errors['location']
            el: $("#popup-instagram-connect")

  handleSave: (event)->
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
        @view = new Agreatfirstdate.Views.User.EditPhotoView(model: @model)
        $("#profile_popup").html(@view.render().el)
        $("#edit_photo").append("<input type='hidden' name='profile[avatars_attributes][][remote_image_url]' value='"+src_big+"'>");
        $('#edit_photo').submit()
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

    modal = new Agreatfirstdate.Views.Application.Modal
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
