Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventItemView extends Backbone.View
  template: JST["backbone/event_items/event_item"]

  initialize: (options) ->
    _.bindAll(this, 'addPreview')

  events:
    "click .destroy" : "destroy"

  tagName: "div"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  addPreview: (eventPhoto) ->
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    $(@el).append(view.render().el)

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @$('.fields').append(JST["backbone/event_items/field"]({label: value.label, value: fieldValue}))
    , this
    @model.eventPhotos.each(@addPreview)

    return this
