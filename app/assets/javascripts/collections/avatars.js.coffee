class Agreatfirstdate.Collections.AvatarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Avatar

  current: ()->
    @first()