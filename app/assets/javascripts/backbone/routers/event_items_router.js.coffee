class Agreatfirstdate.Routers.EventItemsRouter extends Backbone.Router
  initialize: (options) ->
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)
    @place = @pillar.place
    @eventItems = new Agreatfirstdate.Collections.EventItemsCollection()
    @eventItems.url = '/pillars/'+@pillar.id+'/event_items'
    @eventItems.reset options.eventItems

    @route("/pillars/#{@pillar.id}/event_items/:id", 'show')
    @route("/pillars/#{@pillar.id}/event_items/:id/edit", 'edit')
    @route("/pillars/#{@pillar.id}/event_items/new", 'newEventItem')
    _.bindAll(this, "fillEventTypes");
    _.bindAll(this, "saveDialogForm");
    _.bindAll(this, "updateDialogForm");
    @el = $("#event_items_popup")

  routes:
    "/event_items/:id/edit"   : "edit"
    "/event_items/:id"        : "show"

  newEventItem: ->
    @view = new Agreatfirstdate.Views.EventItems.NewView(collection: @eventItems, pillars: @pillars, pillarId: @pillar.id)
    @el.html(@view.render().el)
    @pillar.eventItems.currentModel = @view.model
    @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @view.model.eventPhotos, pillar: @pillar, eventItem: @view.model)
    @el.append(@photoView.render().el)

    @el.dialog({
      title: "Add Event",
      height: 480,
      width: 640,
      resizable: false,
      draggable: false,
      modal: true,
      buttons: {
        "Submit": @saveDialogForm
        "Cancel": -> window.location.hash = ""
      }
    })

  fillEventTypes: (collection, response) ->
    @view.fillTypes(collection)

  saveDialogForm: (e) ->
    @view.save(e)

  updateDialogForm: (e) ->
    @view.update(e)

  index: ->
    @view = new Agreatfirstdate.Views.EventItems.IndexView(eventItems: @eventItems, pillar: @pillar)
    @place.find('.pillar-content').html(@view.render().el)
    @el.empty().dialog('close')

  show: (id) ->
    eventItem = @eventItems.get(id)

    @view = new Agreatfirstdate.Views.EventItems.ShowView(model: eventItem)
    @el.html(@view.render().el)
    @el.dialog({
      title: "View Event",
      height: 480,
      width: 640,
      resizable: false,
      draggable: false,
      modal: true,
      buttons: {
        "Close": -> window.location.hash = ""
      }
    })

  edit: (id) ->
    eventItem = @eventItems.get(id)
    @view = new Agreatfirstdate.Views.EventItems.EditView(model: eventItem)
    @el.html(@view.render().el)
    @pillar.eventItems.currentModel = eventItem
    @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @view.model.eventPhotos, pillar: @pillar, eventItem: eventItem)
    @el.append(@photoView.render().el)
    @el.dialog({
      title: "Edit Event",
      height: 480,
      width: 640,
      resizable: false,
      draggable: false,
      modal: true,
      buttons: {
        "Submit": @updateDialogForm
        "Cancel": -> window.location.hash = ""
      }
    })