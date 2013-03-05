Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Show extends Backbone.View
  template: JST["event_items/show"]
  el: "#event_items_popup"
  
  initialize: (options) ->
    @pillar = options.pillar
    @render()
    
    
  render: ->
    console.log @pillar
    template = @template(
      pillar: @pillar
      # authenticity_token: $("meta[name=csrf-token]").attr('content')
    )
    
    modal = new Agreatfirstdate.Views.Application.Modal
      header: @pillar.get('name')
      body: template
      el: @el
      view: this