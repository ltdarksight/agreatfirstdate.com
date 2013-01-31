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
      $.extend(json, {image: image, photos: @photos.toJSON()})
