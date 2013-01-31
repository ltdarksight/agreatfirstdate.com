class Agreatfirstdate.Collections.PillarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Pillar
  url: '/pillars'

  initialize: (options) ->
    if options
      @allowEdit = options.allowEdit

  toJSON: (filter = true) ->
    @map (model) -> return $.extend(model.toJSON(filter), allowEdit: @allowEdit)

  pillarIds: ->
    @map (pillar)-> pillar.get('pillar_category_id')