Agreatfirstdate.Views.User.Avatars ||= {}

class Agreatfirstdate.Views.User.Avatars.Preview extends Backbone.View
  template: JST['users/avatars/preview']

  events:
    'click .destroy-avatar': 'destroy'
    'click img': 'cropImage'

  destroy: ->
    @model.destroy()

  render: ->
    $(@el).html @template(image: @model.get('image'))

    @

  cropImage: (event) ->
    @options.cropView.setAvatar(@model)
    @
