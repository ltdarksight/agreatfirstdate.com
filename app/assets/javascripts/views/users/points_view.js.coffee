Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PointsView extends Backbone.View
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @setElement($('#my_points'))
    @model.on 'change:points', @render, @

  render: ->
    @prev_points = @model.previous('pounts') || parseInt(@$el.text())
    @current = @model.get('points')
    @$el.countTo
      from: @prev_points
      to: @current
      speed: 5000
      formatter:  (value, options)->
        v = value.toFixed(options.decimals)
        _.pluralize('point', v, true)

    @
