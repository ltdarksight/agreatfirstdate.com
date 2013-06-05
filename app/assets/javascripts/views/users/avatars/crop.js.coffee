Agreatfirstdate.Views.User.Avatars ||= {}

class Agreatfirstdate.Views.User.Avatars.Crop extends Backbone.View
  template: JST["users/avatars/crop"]

  initialize: (options) ->
    super(options)
    _.bindAll(this, 'getCoords')


  setAvatar: (avatar)->
    @model = avatar
    @render()

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
    @$('.large_ img').Jcrop({
      onSelect: @getCoords,
      onChange: @getCoords,
      minSize: [100, 0]
      setSelect: @model.get('bounds'),
      aspectRatio: @model.get('aspect_ratio')}, ->
      window.jcropApi = this
    )
    @
