class Agreatfirstdate.Models.Pillar extends Agreatfirstdate.Models.BaseModel
  paramRoot: 'pillar'
  accessibleAttributes: ['id', 'pillar_category_id']

  defaults:
    pillar_category: null

  initialize: (options)->
    @photos = new Agreatfirstdate.Collections.EventPhotosCollection options.event_photos

  toJSON: (filter = true)->
    json = super filter
    if filter
      json
    else
      image = if @photos.length
        @photos.current().toJSON().image
      else
        {pillar: {url: json.image_url}}
      $.extend(json, {image: image})

class Agreatfirstdate.Collections.PillarsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Pillar
  url: '/pillars'

  initialize: (options) ->
    if options
      @allowEdit = options.allowEdit

  toJSON: (filter = true) ->
    @map (model) -> return $.extend(model.toJSON(filter), allowEdit: @allowEdit)