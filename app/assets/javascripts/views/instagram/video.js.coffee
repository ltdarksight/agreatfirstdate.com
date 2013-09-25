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
    @selected = true
    imageUrl = @model.get('images').standard_resolution.url
    videoUrl = @model.get('videos').standard_resolution.url
    @selectedPhotos.add
      url: imageUrl
      videoUrl: videoUrl
      kind: 'video'
    @$('.instagram-photo').addClass('selected')

    false