Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowView extends Backbone.View
  template: JST["backbone/event_items/show/show"]

  render: ->
    currentIndex = @collection.indexOf @model
    previous = @collection.at((if 0 == currentIndex then @collection.length else currentIndex) - 1).id
    next = @collection.at(if @collection.length-1 == currentIndex then 0 else currentIndex+1).id
    $(@el).html @template($.extend(@model.toJSON(false), {previous: previous, next: next, pillar: @collection.pillar.toJSON()}))
    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/show/field"]({label: value.label, value: fieldValue}))
    , this
    if @model.eventPhotos.length
      view = new Agreatfirstdate.Views.EventItems.ShowPhotosView({model: @model})
      @$('.images').html(view.render().el)
    return this
