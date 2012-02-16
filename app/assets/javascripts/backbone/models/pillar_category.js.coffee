class Agreatfirstdate.Models.PillarCategory extends Backbone.Model
  paramRoot: 'pillar_category'

  defaults:
    title: null
    description: null

class Agreatfirstdate.Collections.PillarCategoriesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.PillarCategory
  url: '/pillar_categories'

  comparator: (pillarCategory) ->
    -parseInt(pillarCategory.id)