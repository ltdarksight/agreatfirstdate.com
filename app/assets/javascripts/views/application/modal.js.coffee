Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Modal extends Backbone.View
  template : JST["application/modal"]

  defaults:
    allowSave: true
    allowClose: true

  initialize: ->
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
    @body = @options.body
    @view = @options.view

    @show()

  events:
    'hidden': 'removeEvent'
    'click .close-btn': 'handleClose'

  handleClose: (event)->


  removeEvent: ->
    if @view
      @view.undelegateEvents()
    window.location.hash = ''

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
      allowSave: @.options.allowSave
      })
    )
    @
