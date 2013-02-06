class Agreatfirstdate.Collections.Pillars extends Backbone.Collection
  url: '/api/pillars'
  model: Agreatfirstdate.Models.Pillar
  
  # initialize: (options) ->
  #   if options
  #     @allowEdit = options.allowEdit
  # 
  # pillarIds: ->
  #   @map (pillar)-> pillar.get('pillar_category_id')