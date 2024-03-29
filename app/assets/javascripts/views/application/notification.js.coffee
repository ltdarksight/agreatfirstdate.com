Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Notification extends Backbone.View
  template : JST["application/modal"]
  el: "#popup-notification"

  defaults:
    allowSave: false
    allowClose: true
    saveText: 'Save'
    closeText: 'Close'
    typeClose: 'link'
    saveHref: '#'
    spinner: false

  initialize: ->
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
    @body = @options.body
    @view = @options.view
    @saveHref = @options.saveHref
    @spinner = @options.spinner

    @show()

  events:
    'click .close-btn': 'handleClose'

  handleClose: (event)->

  show: ->
    @render()
    @.$el.modal('show').css "margin-top": ->
      window.pageYOffset - ($(this).height() / 2) + 50

  hide: ->
    @.$el.modal('hide')

  render: ->
    @.$el.html(@template({
      header: @header,
      body: @body,
      allowClose: @.options.allowClose,
      typeClose: @.options.typeClose,
      allowSave: @.options.allowSave,
      saveText: @.options.saveText,
      closeText: @.options.closeText,
      saveHref: @.options.saveHref
      spinner: @.options.spinner
      })
    )
    @
