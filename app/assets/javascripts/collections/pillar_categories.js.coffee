class Agreatfirstdate.Collections.PillarCategories extends Backbone.Collection
  url: '/api/pillar_categories'
  model: Agreatfirstdate.Models.PillarCategory
  
  # comparator: (pillarCategory) ->
  #   -parseInt(pillarCategory.id)