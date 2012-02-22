Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PhotoView extends Backbone.View
  className: 'profile-photo'

  initialize: (options) ->
    super(options)
    @template = JST["backbone/user/photo/show#{if @model.allowEdit then '' else '_guest'}"]
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
    $(@el).html @template(@model.toJSON(false))
    return this
