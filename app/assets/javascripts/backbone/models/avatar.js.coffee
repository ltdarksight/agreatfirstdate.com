class Agreatfirstdate.Models.Avatar extends Backbone.Model
  paramRoot: 'avatar'

  defaults:
    image: null

class Agreatfirstdate.Collections.AvatarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar

  initialize: (models, options)->
    super(models, options)

  current: ->
    @first()