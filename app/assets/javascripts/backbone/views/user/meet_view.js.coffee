Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.MeetView extends Backbone.View
  template: JST["backbone/user/meet"]
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @model.on 'sync', (model) ->
      @render()
    , this

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
