Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.EventItemView extends Backbone.View
  template: JST["event_items/event_item"]
  hintTemplate: JST["event_items/hint_information"]

  initialize: (options) ->
    @offset = options.offset
    _.bindAll(this, 'showHint', 'hideHint', 'addPreview')
    $(@el).hover @showHint, @hideHint

  events:
    "click .destroy" : "destroy"
    "click" : "show"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  show: ->
    location.hash = "#/pillars/#{@model.get('pillar_id')}/event_items/#{@model.id}"

  hideHint: () ->
    @hint.remove()

  showHint: () ->
    $(@el).append(@hintTemplate(@model.toJSON(false)))
    @hint = @$('#event_item_hintbox')

  addPreview: (eventPhoto) ->
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    @hint.append(view.render().el)

  render: ->
    $(@el).html @template($.extend(@model.toJSON(false), {offset: @offset}))
    @offset -= 5 if @offset > 0
    $(@el).css({'margin-top': @offset})
    return this