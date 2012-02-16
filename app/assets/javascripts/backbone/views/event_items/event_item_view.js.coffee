Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventItemView extends Backbone.View
  template: JST["backbone/event_items/event_item"]
  hintTemplate: JST["backbone/event_items/hint_information"]

  initialize: (options) ->
    @position = options.position
    @hint = $('#event_item_hint')
    _.bindAll(this, 'addPreview')

  events:
    "click .destroy" : "destroy"
    "mouseover" : "showHint"
    "mouseout" : "hideHint"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  hideHint: () ->
    @hint.empty()

  showHint: () ->
    @hint.show();
    $(@hint).html(@hintTemplate(@model.toJSON(false)))
    _.each @model.toJSON(false).fields, (value, iteratorId, list) ->
      fieldValue = @model.attributes[value.field]
      if (fieldValue)
        @hint.find('.fields').append(JST["backbone/event_items/show/field"]({label: value.label, value: fieldValue}))
    , this
    @model.eventPhotos.each(@addPreview)

  addPreview: (eventPhoto) ->
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    @hint.append(view.render().el)

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false), {position: @position}))
    return this
