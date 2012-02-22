class Agreatfirstdate.Models.Pillar extends Agreatfirstdate.Models.BaseModel
  paramRoot: 'pillar'
  accessibleAttributes: ['id', 'pillar_category_id']

  defaults:
    pillar_category: null

class Agreatfirstdate.Collections.PillarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Pillar
  url: '/pillars'

  initialize: (options) ->
    if options
      @allowEdit = options.allowEdit

  toJSON: (filter = true) ->
    @map (model) -> return $.extend(model.toJSON(filter), allowEdit: @allowEdit)