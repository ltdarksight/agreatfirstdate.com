class Agreatfirstdate.Models.UserPillars extends Backbone.Model
  paramRoot: 'user_pillar'
  urlRoot: '/me/select_pillars/'
  defaults:
    pillars_attributes: []

  count: ->
    _.reduce @get('pillars_attributes'), (memo, pillar)->
      memo + if pillar._destroy then 0 else 1
    , 0
