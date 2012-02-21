Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhotoLargeView extends Backbone.View
  template: JST["backbone/user/photo/large"]

  initialize: (options) ->
    super(options)
    @user = options.user
    _.bindAll(this, 'getCoords')

  events:
    'click .crop_': 'crop'

  getCoords: (c)->
    @model.set('bounds', [c.x, c.y, c.x2, c.y2])

  crop: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.save(null, {success: (model, response) ->
      @model = model
      model.trigger('crop')
    })

  render : ->
    $(@el).html(@template(@model.toJSON()))
    @$('img').Jcrop({
      onSelect: @getCoords,
      onChange: @getCoords,
      minSize: [100, 0]
      setSelect: @model.get('bounds'),
      aspectRatio: @model.get('aspect_ratio')}, ->
      window.jcropApi = this
    )
    return this