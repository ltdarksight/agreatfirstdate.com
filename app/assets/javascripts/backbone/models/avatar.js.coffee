class Agreatfirstdate.Models.Avatar extends Backbone.Model
  paramRoot: 'avatar'

  defaults:
    image: null

  urlRoot: '/avatars'

class Agreatfirstdate.Collections.AvatarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar

  initialize: (models, options)->
    super(models, options)

  current: ->
    @first()