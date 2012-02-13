Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ShowView extends Backbone.View
  template: JST["backbone/templates/pillars/show"]
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
