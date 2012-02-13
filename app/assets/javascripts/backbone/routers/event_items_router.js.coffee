class Agreatfirstdate.Routers.EventItemsRouter extends Backbone.Router
  initialize: (options) ->
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)
    @place = @pillar.place
    @eventItems = new Agreatfirstdate.Collections.EventItemsCollection()
    @eventItems.url = '/pillars/'+@pillar.id+'/event_items'
    @eventItems.reset options.eventItems
#    @eventItems.fetch()
    @eventPhotos = new Agreatfirstdate.Collections.EventPhotosCollection()

    @route("/pillars/#{@pillar.id}/event_items/:id", 'show')
    @route("/pillars/#{@pillar.id}/event_items/:id/edit", 'edit')
    @route("/pillars/#{@pillar.id}/event_items/new", 'newEventItem')
    _.bindAll(this, "fillEventTypes");
    @el = $("#event_items_popup")

  routes:
    "/event_items/:id/edit"   : "edit"
    "/event_items/:id"        : "show"

  newEventItem: ->
    @view = new Agreatfirstdate.Views.EventItems.NewView(collection: @eventItems, pillars: @pillars, pillarId: @pillar.id)
    @eventTypes = new Agreatfirstdate.Collections.EventTypesCollection()
    @eventTypes.url = '/pillars/'+@pillar.id+'/event_types'

    @eventTypes.fetch {success: @fillEventTypes}
    @el.html(@view.render().el)
    @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @eventPhotos)
    @el.append(@photoView.render().el)

  fillEventTypes: (collection, response) ->
    @view.fillTypes(collection)

  index: ->
    @view = new Agreatfirstdate.Views.EventItems.IndexView(eventItems: @eventItems, pillar: @pillar)
    @place.find('.pillar-content').html(@view.render().el)
    @el.empty()

  show: (id) ->
    eventItem = @eventItems.get(id)

    @view = new Agreatfirstdate.Views.EventItems.ShowView(model: eventItem)
    @el.html(@view.render().el)

  edit: (id) ->
    eventItem = @eventItems.get(id)

    @view = new Agreatfirstdate.Views.EventItems.EditView(model: eventItem)
    @el.html(@view.render().el)
