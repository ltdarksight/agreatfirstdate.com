Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Modal extends Backbone.View
  template : JST["application/modal"]
  className: "modal fade hide"


  defaults:
    allowSave: true
    allowClose: true
    saveText: 'Save'

  initialize: ->
    #$(window).on "resize", 'handleShown', @
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
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
    "shown" : 'handleShown'

  handleShown: (event) ->
    @$(".modal-body").css
      'max-height': ($(document).height() * .8) + 'px'

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
    @.$el.html(@template({
      header: @header,
      body: @body,
      allowClose: @.options.allowClose,
      allowSave: @.options.allowSave
      saveText: @.options.saveText
      })
    )
    @
