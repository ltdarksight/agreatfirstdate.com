Agreatfirstdate.Views.User.Avatars ||= {}

class Agreatfirstdate.Views.User.Avatars.Preview extends Backbone.View
  template: JST['users/avatars/preview']
  initialize: ->
    @model.on "crop", @render, @

  events:
    'click .destroy-avatar': 'destroy'
    'click img.avatar-preview': 'cropImage'

  destroy: ->
    @options.parentView.destroyAvatar(@)

  render: ->
    $(@el).html @template(image: @model.get('image'))

    @

  cropImage: (event) ->
    @options.cropView.setAvatar(@model)
    @
