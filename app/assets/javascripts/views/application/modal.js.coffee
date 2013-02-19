Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Modal extends Backbone.View
  template : JST["application/modal"]
  
  initialize: (options) ->
    @header = options.header
    @body = options.body
    
    $(@el).html(@render())
    $(@el).modal('show')
    
    # $("#profile_popup").on "hidden", ->
  
  events:
    'hidden': 'removeEvent'
    
  removeEvent: ->
    $(@el).off('click', '.save');
    
  render: ->
    @template
      header: @header
      body: @body