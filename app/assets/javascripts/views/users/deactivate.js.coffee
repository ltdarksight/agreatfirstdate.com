Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.Deactivate extends Backbone.View

  template : JST["users/deactivate"]
  el: '#deactivateView'

  events:
    "click .save" : 'handleSubmit'

  initialize: ->
    _.bindAll @, 'handleSubmit'
    @me = @.options.me

  handleSubmit: (event)->
    data = $.param(reason: @$('#reason').val())
    @model.deactivate
      attrs:
        reason:  @$('#reason').val()
      success: (user) =>
        @model.set('status', user.status)
        @modal.hide()

  render: ->
    template = @template()

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Agreatfirstdate - Deactivate profile'
      body: template
      el: @el
      view: @
      saveText: 'Deactivate'

    @
