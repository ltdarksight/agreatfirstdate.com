Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.MeetView extends Backbone.View
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @template = JST["users/meet#{if @model.allowEdit then '' else '_guest'}"]
    @model.on 'change:who_meet', @render, this

  render: ->
    $(@el).html @template(@model.toJSON(false))
    return this