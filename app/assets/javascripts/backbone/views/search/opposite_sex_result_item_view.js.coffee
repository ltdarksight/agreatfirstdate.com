Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.OppositeSexResultItemView extends Backbone.View
  template: JST["backbone/search/opposite_sex/result_item"]

  render: ->
    $(@el).html @template(@model.toJSON(false))
    return this
