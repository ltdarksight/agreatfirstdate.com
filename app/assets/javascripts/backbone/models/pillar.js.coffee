class Agreatfirstdate.Models.Pillar extends Backbone.Model
  paramRoot: 'pillar'

  defaults:
    pillar_category: null

  initialize: (options) ->
    if options
      false #set relations

class Agreatfirstdate.Collections.PillarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Pillar
  url: '/pillars'
