Agreatfirstdate.Views.Instagram ||= {}

class Agreatfirstdate.Views.Instagram.Photo extends Backbone.View
  template: JST['instagram/photo']
  tagName: 'li'
  className: 'photo-item'

  initialize: (options) ->
    @parent = options.parent
    @selectedPhotos = options.selectedPhotos
    @selected = false

  events:
    'click .instagram-photo': 'select'

  render: ->
    $(@el).html @template(id: @model.id, images: @model.get('images'))
    this

  select: ->
    @selected = true
    imageUrl = @model.get('images').standard_resolution.url
    @selectedPhotos.add
      url: imageUrl

    @$('.instagram-photo').addClass('selected')

    false