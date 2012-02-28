Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PhotoView extends Backbone.View
  className: 'profile-photo'

  initialize: (options) ->
    super(options)
    @template = JST["backbone/user/photo/show#{if @model.allowEdit then '' else '_guest'}"]
    @getCurrent()
    @model.avatars.on 'reset', (collection)=>
      @getCurrent()
      @render()
    @model.avatars.on 'change:current', (collection)=>
      if @model.avatars.length && (!@avatar || @avatar.id != @model.avatars.current().id)
        @getCurrent()
        @$('.cache_').remove()
        $(@el).append(@make('div', {class: 'cache_', style: 'display: none'}, @template(@model.toJSON(false))))
        $(@el).flip
          color: '#FBFBFB'
          direction:'tb',
          content: @$('.cache_').html()

  getCurrent: ->
    @avatar = @model.avatars.current()
    if @avatar
      @avatar.on 'crop', =>
        @render()

  render: ->
    $(@el).html @template(@model.toJSON(false))
    return this
