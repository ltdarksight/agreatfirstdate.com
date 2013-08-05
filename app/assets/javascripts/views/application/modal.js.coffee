Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Modal extends Backbone.View
  template : JST["application/modal"]
  className: "modal fade hide"


  defaults:
    allowSave: true
    allowClose: true
    saveText: 'Save'
    saveHref: '#'
    closeText: 'Close'

  initialize: ->
    #$(window).on "resize", 'handleShown', @
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
    @saveHref = @options.saveHref
    @spinner = false
    if @options.body
      @body = @options.body
      @view = @options.view
      @show()
    else if @options.url
      @view = @options.view
      $("<div />").load @options.url, (data) =>
        @body = data
        @show()



  events:
    'hidden': 'removeEvent'
    'click .close-btn': 'handleClose'
    "show" : 'handleShown'

  handleShown: (event) ->
    @.$el.css
      'margin-top':  window.pageYOffset

  handleClose: (event)->


  removeEvent: ->
    if @view and @view.undelegateEvents
      @view.undelegateEvents()
    window.location.hash = ''

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
      allowSave: @.options.allowSave
      saveText: @.options.saveText
      closeText: @.options.closeText
      saveHref: @.options.saveHref
      spinner: false
      })
    )
    @
