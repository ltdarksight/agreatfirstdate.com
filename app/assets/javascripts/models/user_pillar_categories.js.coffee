class Agreatfirstdate.Models.UserPillarCategories extends Backbone.Model

  paramRoot: 'pillar_categories'

  update_categories: (options)->
    @sync('update', @, _.extend({url: "/api/pillar_categories" }, options))
