Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Meet extends Backbone.View
  className: 'pillar-content'
  template : JST["users/meet"]

  initialize: ->
    @model.on 'change:who_meet', @render, this

  render: ->
    $(@el).html @template(who_meet: @model.get('who_meet'), profile: @model)

    @
