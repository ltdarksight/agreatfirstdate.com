Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PointsView extends Backbone.View
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @setElement($('#my_points'))
    @model.on 'change:points', (model, value)=>
      @render()

  render: ->
    $(@el).html _.pluralize('point', @model.get('points'), true)
    return this
