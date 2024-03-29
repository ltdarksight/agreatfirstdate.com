Agreatfirstdate.Views.User.Avatars ||= {}

class Agreatfirstdate.Views.User.Avatars.Crop extends Backbone.View
  template: JST["users/avatars/crop"]
  el: $(".crop-wrapper")

  initialize: (options) ->
    super(options)
    _.bindAll(this, 'getCoords')


  setAvatar: (avatar)->
    @model = avatar
    @render()

  getCoords: (c)->
    @model.bounds = [c.x, c.y, c.x2, c.y2]

  crop: (e)->
    e.preventDefault()
    e.stopPropagation()
    $(".large_").css
      opacity: .45

    @spinner = new Agreatfirstdate.Views.Application.Spinner()
    @spinner.show()

    data = { avatar:{ bounds: @model.bounds }}
    @model.save data,
      success: (model, response) =>
        model.trigger('crop')
        $(".large_").css
          opacity: 1
        @spinner.hide()
      error: (model, response) =>
        @spinner.hide()

  render : ->
    $(@el).html(@template(@model.toJSON()))
    @$('.large_ img').Jcrop({
      onSelect: @getCoords,
      onChange: @getCoords,
      minSize: [150, 0]
      setSelect: @model.get('bounds'),
      boxWidth: 440,
      boxHeight: 330
      aspectRatio: @model.get('image').aspect_ratio}, ->
      window.jcropApi = this

    )
    $(@.$el.parents(".modal-body:first")).css
      'min-height': '470px'
    @
