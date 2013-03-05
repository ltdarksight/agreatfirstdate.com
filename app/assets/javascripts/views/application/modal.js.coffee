Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Modal extends Backbone.View
  template : JST["application/modal"]
  
  initialize: (options) ->
    @header = options.header
    @body = options.body
    @view = options.view
    
    $(@el).html(@render())
    $(@el).modal('show')
  
  events:
    'hidden': 'removeEvent'
    
  removeEvent: ->
    @view.undelegateEvents()
    
  render: ->
    @template
      header: @header
      body: @body