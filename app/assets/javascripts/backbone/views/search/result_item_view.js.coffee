Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultItemView extends Backbone.View
  template: JST["backbone/search/result_item"]

  initialize: (options) ->
    super

  events:
    "click" : "show"

  show: ->
    location.hash = "#/profile/#{@model.get('id')}"

  render: ->
    console.log @model
    @avatar = @model.avatars.current()
    $(@el).html @template($.extend(@model.toJSON(), {avatar: if @avatar then @avatar.toJSON() else null}))
    return this
