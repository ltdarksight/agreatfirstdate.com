class Agreatfirstdate.Models.EventItem extends Backbone.Model
  methodUrl:
    'activate': '/event_items/:id/activate'
    'deactivate': '/event_items/:id/deactivate'
    'still_inappropriate': '/event_items/:id/still_inappropriate'
  defaults:
    id: null
    text_1: ''
    text_2: ''
    string_1: ''
    string_2: ''
    date_1: null
    date_2: null
    pillar_id: null
    event_photo_ids: []
    title: ''
    description: ''

  initialize: (options) ->
    @eventPhotos = new Agreatfirstdate.Collections.EventPhotos()
    @eventDescriptors = new Agreatfirstdate.Collections.EventDescriptorsCollection()
    if options
      @calcDistance(options.date_1)
      @eventType = new Agreatfirstdate.Models.EventType(options.event_type if options.event_type)
      @eventDescriptors.reset @eventType.toJSON().event_descriptors if @eventType
      @eventPhotos.reset options.event_photos if options.event_photos
      @inappropriateContent = new Agreatfirstdate.Models.InappropriateContent(options.inappropriate_content)

  sync: (method, model, options) =>
    options = options || {}
    if _.include _(@methodUrl).keys(), method
      options.url = @methodUrl[method.toLowerCase()].replace(':id', model.id);
      method = 'update'
    Backbone.sync(method, model, options)

  hasDate: ->
    _.include(_.map(@toJSON(false).fields, (field)-> field.field), 'date_1')

  calcDistance: (postedAt)->
    date = new Date()
    date.setTime(Date.parse(postedAt))
    @set('date', date, silent: true)
    @distance = Math.floor((new Date() - date)/(1000 * 60 * 60 * 24))

