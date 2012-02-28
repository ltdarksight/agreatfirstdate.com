class Agreatfirstdate.Models.Avatar extends Backbone.Model
  paramRoot: 'avatar'

  defaults:
    image: null

  urlRoot: '/avatars'

class Agreatfirstdate.Collections.AvatarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar

  currentId: null

  initialize: (models, options)->
    super(models, options)
    @currentId = Math.round(Math.random()*(@length-1))

  current: ()->
    current = @at(@currentId)
    if current then current else @first()

  changeCurrent: =>
    if @length > 1
      currentId = @currentId
      while @currentId == currentId
        @currentId = Math.round(Math.random()*(@length-1))
      @trigger('change:current', this, @current())