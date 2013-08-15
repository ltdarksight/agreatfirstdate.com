Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Video extends Backbone.View
  template : JST["application/video"]
  className: "modal fade hide"


  defaults:
    allowSave: false
    allowClose: true
    typeClose: 'link'
    saveText: 'Save'
    saveHref: '#'
    closeText: 'Close'

  initialize: ->
    #$(window).on "resize", 'handleShown', @
    @.options = _.defaults(@.options, @.defaults)
    @header = @options.header
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
      sources: [{url: @.options.source_url, type: 'mp4' }]
      })
    )

    @
