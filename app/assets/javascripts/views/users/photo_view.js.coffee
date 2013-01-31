Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PhotoView extends Backbone.View
  className: 'profile-photo'

  initialize: (options) ->
    super(options)
    @template = JST["users/photos/show#{if @model.allowEdit then '' else '_guest'}"]
    @getCurrent()
    @model.avatars.on 'reset', (collection)=>
      @getCurrent()
      @render()

  getCurrent: ->
    @avatar = @model.avatars.current()
    if @avatar
      @avatar.on 'crop', =>
        @render()

  render: ->
    $(@el).html @template(@model.toJSON(false))
    if @model.avatars.length>0
      items = @$(".carousel-inner .item")
      items.eq(Math.floor(Math.random()*items.length)).addClass "active"
      @$(".carousel").carousel interval: 30000
    return this