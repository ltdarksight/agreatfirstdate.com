Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Empty extends Backbone.View
  template: JST["pillars/empty"]

  render: ->
    $(@el).html(@template())
    this