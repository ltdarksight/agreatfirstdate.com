Agreatfirstdate.Views.User.Avatars ||= {}

class Agreatfirstdate.Views.User.Avatars.Preview extends Backbone.View
  template: JST['users/avatars/preview']

  events:
    'click .destroy-avatar': 'destroy'
    'click img': 'showLarge'

  destroy: ->
    @model.destroy()

  render: ->
    $(@el).html @template(image: @model.get('image'))

    @

  showLarge: (e)->
    $(".crop-image").unbind("click")
    @largeView = new Agreatfirstdate.Views.User.Avatars.Crop({model: @model, el: $(".crop-wrapper") })
    @largeView.render()
