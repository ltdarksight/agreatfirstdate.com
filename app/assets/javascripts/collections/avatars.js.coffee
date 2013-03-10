class Agreatfirstdate.Collections.Avatars extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar
  url: 'api/profiles/avatars'

  current: ()->
    @first()