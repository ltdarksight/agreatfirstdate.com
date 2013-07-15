Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Notification extends Backbone.View
  template : JST["application/modal"]
  el: "#popup-notification"

  defaults:
    allowSave: false
    allowClose: true
    saveText: 'Save'
    closeText: 'Close'

  initialize: ->
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
    @body = @options.body
    @view = @options.view

    @show()

  events:
    'click .close-btn': 'handleClose'

  handleClose: (event)->

  show: ->
    @render()
    @.$el.modal('show')

  hide: ->
    @.$el.modal('hide')

  render: ->
    @.$el.html(@template({
      header: @header,
      body: @body,
      allowClose: @.options.allowClose,
      allowSave: @.options.allowSave,
      saveText: @.options.saveText,
      closeText: @.options.closeText

      })
    )
    @
