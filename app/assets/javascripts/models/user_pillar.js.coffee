class Agreatfirstdate.Models.UserPillar extends Backbone.Model
  paramRoot: 'user_pillar'
  urlRoot: '/me/select_pillars/'
  defaults:
    selected_pillar_ids: []

  count: ->
    @get('selected_pillar_ids').length