Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.Video extends Backbone.View
  template: JST['instagram/video']
  tagName: 'li'
  className: 'photo-item'

  initialize: (options) ->
    @parent = options.parent
    @selectedPhotos = options.selectedPhotos
    @selected = false

  events:
    'click .instagram-photo': 'select'

  render: ->
    $(@el).html @template
      id: @model.id
      images: @model.get('images')
      videos: @model.get('videos')
    this

  select: ->
    item = $(@el).find('.instagram-photo')
    photos_count = $(@parent.el).find('.photos_count span')
    photosCountValue = photos_count.html()
    if item.hasClass('selected')
      item.removeClass('selected')
      photos_count.html(--photosCountValue)
      @selectedPhotos.remove @eventPhoto
    else
      item.addClass('selected')
      photos_count.html(++photosCountValue)
      imageUrl = @model.get('images').standard_resolution.url
      videoUrl = @model.get('videos').standard_resolution.url
      @eventPhoto = new @selectedPhotos.model
        url: imageUrl
        videoUrl: videoUrl
        kind: 'video'
      @selectedPhotos.add(@eventPhoto)

    false