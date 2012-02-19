Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PhotoView extends Backbone.View
  template: JST["backbone/user/photo/show"]

  className: 'profile-photo'

  initialize: (options) ->
    super(options)
    @getCurrent()
    @model.avatars.on 'reset', (collection)->
      @getCurrent()
      @render()
    , this

  getCurrent: ->
    @avatar = @model.avatars.current()
    if @avatar
      @avatar.on 'crop', ->
        @render()
      , this

  render: ->
    $(@el).html(@template($.extend(@model.toJSON(), {avatar: if @avatar then @avatar.toJSON() else null})))
    return this
