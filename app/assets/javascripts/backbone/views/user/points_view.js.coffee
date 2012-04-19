Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.PointsView extends Backbone.View
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @setElement($('#my_points'))
    @model.on 'change:points', => @tick()

  render: ->
    @current ||= @model.get('points')
    if @current >= @model.get('points')
      @timer_is_on = false
      @current = @model.get('points')
    else
      @current++
      setTimeout =>
        @render()
      , 500
    $(@el).html _.pluralize('point', @current, true)
    return this

  tick: ->
    unless @timer_is_on
      @timer_is_on = true
      @render()
