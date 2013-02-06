class Agreatfirstdate.Collections.Avatars extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar

  current: ()->
    @first()