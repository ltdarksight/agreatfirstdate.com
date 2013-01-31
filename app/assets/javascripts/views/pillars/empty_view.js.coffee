Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.EmptyView extends Backbone.View
  initialize: ()->
    super
    @template = JST["pillars/empty#{if @collection.allowEdit then '' else '_guest'}"]

  render: ->
    $(@el).html(@template())
    return this