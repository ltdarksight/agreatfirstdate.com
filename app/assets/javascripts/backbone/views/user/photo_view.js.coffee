Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PhotoView extends Backbone.View
  template: JST["backbone/user/photo/show"]

  className: 'profile-photo'

  initialize: (options) ->
    super(options)
    @model.avatars.on 'reset', (collection)->
      @render()
    , this

  render: ->
    @avatar = if @model.avatars.length then @model.avatars.current().toJSON() else null
    $(@el).html(@template($.extend(@model.toJSON(), {avatar: @avatar})))
    return this
