class Agreatfirstdate.Collections.PillarCategoriesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.PillarCategory
  url: '/pillar_categories'

  comparator: (pillarCategory) ->
    -parseInt(pillarCategory.id)