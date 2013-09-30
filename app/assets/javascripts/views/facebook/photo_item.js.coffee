Agreatfirstdate.Views.Facebook ||= {}

class Agreatfirstdate.Views.Facebook.PhotoItem extends Backbone.View
  template: JST["facebook/photo_item"]
  tagName: 'li'
  className: 'photo-item'

  initialize: (options) ->
    @parent = options.parent
    @selectedPhotos = options.selectedPhotos

  events:
    'click .facebook-photo': 'select'

  render: ->
    $(@el).html @template(model: @model)
    this

  select: ->
    item = $(@el).find('.facebook-photo')
    photos_count = $(@parent.el).find('.photos_count span')
    photosCountValue = photos_count.html()
    if item.hasClass('selected')
      item.removeClass('selected')
      photos_count.html(--photosCountValue)
      @selectedPhotos.remove @eventPhoto
    else
      item.addClass('selected')
      photos_count.html(++photosCountValue)
      @eventPhoto = new @selectedPhotos.model
        url: @model.src_big
      @selectedPhotos.add(@eventPhoto)

    false
