Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.Media extends Backbone.View
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
    @$('.loader').hide()
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

      $(@el).find('.instagram-photos').append item.render().el
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
    @modal.hide()
    false

  handleCloseSubwindow: ->
    @.options.parent.trigger "subwindow:close" if @.options.parent


  appendRender: (collection, response) ->
    @$('.loader').hide()
    collection.each (item)=>
      @.$('.instagram-photos').append(@photoItemTemplate(item.toJSON()))

  render: ->
    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Import from instagram'
      body: @template()
      el: @el
      view: @

    @infiniScroll = new Backbone.InfiniScroll @collection,
      target: @$('.row-fluid')
      pageSize: 18
      param: 'max_id'
      success: @appendRender
      onFetch: =>
        @$('.loader').show()

    this
