Agreatfirstdate.Views.Shared ||= {}

class Agreatfirstdate.Views.Shared.DeactivateView extends Backbone.View
  template : JST["backbone/shared/deactivate"]

  initialize: (options)->
    super options
    @me = options.me

  update: ->
    @model.sync 'deactivate', @model, data: $.param(reason: @$('#reason').val()), success: (user)=>
      @model.set('status', user.status)

  render : ->
    $(@el).html(@template(@model.toJSON(false)))
    return this
