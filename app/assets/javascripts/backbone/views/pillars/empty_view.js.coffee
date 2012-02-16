Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.EmptyView extends Backbone.View
  template: JST["backbone/pillars/empty"]

  render: ->
    $(@el).html(@template())
    return this
