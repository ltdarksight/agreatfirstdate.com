Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventItemView extends Backbone.View
  template: JST["backbone/event_items/event_item"]

  initialize: (options) ->
    @position = options.position
    _.bindAll(this, 'addPreview')

  events:
    "click .destroy" : "destroy"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  addPreview: (eventPhoto) ->
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    $(@el).append(view.render().el)

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false), {position: @position}))
    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/field"]({label: value.label, value: fieldValue}))
    , this
    @model.eventPhotos.each(@addPreview)

    return this
