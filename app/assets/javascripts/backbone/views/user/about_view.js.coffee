Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.AboutView extends Backbone.View
  className: 'pillar-content'

  initialize: (options) ->
    super(options)
    @template = JST["backbone/user/about#{if @model.allowEdit then '' else '_guest'}"]
    @model.on 'sync', (model) ->
      @render()
    , this

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    return this
