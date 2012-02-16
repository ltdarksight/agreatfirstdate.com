class Agreatfirstdate.Routers.EventItemsRouter extends Backbone.Router
  initialize: (options) ->
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)
    @pillar.eventItems = new Agreatfirstdate.Collections.EventItemsCollection(null, pillar: @pillar)
    @eventItems = @pillar.eventItems
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

    @showDialog(@el, {
      title: "ADD AN EVENT",
      buttons: {
        "Submit": @saveDialogForm
        "Cancel": -> $(this).dialog('close')
      }
    })

  fillEventTypes: (collection, response) ->
    @view.fillTypes(collection)

  saveDialogForm: (e) ->
    @view.save(e)

  updateDialogForm: (e) ->
    @view.update(e)

  index: (view) ->
    @view = new Agreatfirstdate.Views.EventItems.IndexView(eventItems: @eventItems, pillar: @pillar)
    $(view.el).find('.pillar-content').html(@view.render().el)
    @el.empty().dialog('close')

  show: (id) ->
    eventItem = @eventItems.get(id)

    @view = new Agreatfirstdate.Views.EventItems.ShowView(model: eventItem, collection: @eventItems)
    @el.html(@view.render().el)
    @showDialog(@el, {title: eventItem.eventType.get('title')})

  edit: (id) ->
    eventItem = @eventItems.get(id)
    @view = new Agreatfirstdate.Views.EventItems.EditView(model: eventItem, pillar: @pillar)
    @el.html(@view.render().el)
    @pillar.eventItems.currentModel = eventItem
    @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @view.model.eventPhotos, pillar: @pillar, eventItem: eventItem)
    @el.append(@photoView.render().el)
    @showDialog(@el, {
      title: "Edit Event",
      buttons: {
        "Submit": @updateDialogForm
        "Cancel": -> $(this).dialog('close')
      }
    })

  showDialog: (el, options) ->
    el.dialog($.extend(
      {
        title: "aGreatFirstDate",
        height: 486,
        width: 640,
        resizable: false,
        draggable: false,
        modal: true,
        buttons: {
          "Close": -> $(this).dialog('close')
        },
        close: ->
          location.hash = "/index"
      }, options)
    )