Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Confirm extends Backbone.View
  className: 'modal fade confirm'
  template : JST["application/confirm"]

  defaults:
    allowSave: true
    allowClose: true
    saveText: 'Ok'
    closeText: 'Close'

  events:
    'click .close-btn': 'handleClose'
    'click .btn.save': 'handleOk'
    "show" : 'handleShown'

  initialize: ->
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
    @body = @options.body
    @view = @options.view

    @show()

  handleOk: (event) ->
    if @.options.success
      @.options.success()
    false

  handleShown: (event) ->
    @.$el.css
      'margin-top':  window.pageYOffset

  handleClose: (event)->

  show: ->
    @render()
    @.$el.modal('show')

  hide: ->
    @.$el.modal('hide')

  render: ->
    @.$el.css
      'margin-top':  window.pageYOffset

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
