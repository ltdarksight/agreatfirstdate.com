class Agreatfirstdate.Models.EventPhoto extends Backbone.Model
  paramRoot: 'event_photo'

  defaults:
    image: null

class Agreatfirstdate.Collections.EventPhotosCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventPhoto
  url: '/event_photos'

  currentId: null

  current: ()->
    current = @at(@currentId)
    if current
      current
    else
      @currentId = Math.round(Math.random()*(@length-1))
      @at(@currentId)

  changeCurrent: =>
    if @length > 1
      currentId = @currentId
      while @currentId == currentId
        @currentId = Math.round(Math.random()*(@length-1))
      @trigger('change:current', this, @current())
