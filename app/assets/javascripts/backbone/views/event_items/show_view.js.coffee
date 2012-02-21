Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.ShowView extends Backbone.View
  template: JST["backbone/event_items/show/show"]

  initialize: (options)->
    super
    currentIndex = @collection.indexOf @model
    @previous = @collection.at((if 0 == currentIndex then @collection.length else currentIndex) - 1)
    @next = @collection.at(if @collection.length-1 == currentIndex then 0 else currentIndex+1)

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false), {previous: @previous.id, next: @next.id, pillar: @collection.pillar.toJSON()}))
    unless @previous == @next
      _.each [@previous, @next], (event)->
        view = new Agreatfirstdate.Views.EventItems.EventPreviewView({model: event})
        @$('.events').append(view.render().el)
      , this

    unless @model.hasDate
      @$('.fields').append(JST["backbone/event_items/show/field"]({label: 'Posted', value: @model.get('date_1')}))

    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/show/field"]({label: value.label, value: fieldValue}))
    , this
    if @model.eventPhotos.length
      view = new Agreatfirstdate.Views.EventItems.ShowPhotosView({model: @model})
      @$('.images').html(view.render().el)
    return this
