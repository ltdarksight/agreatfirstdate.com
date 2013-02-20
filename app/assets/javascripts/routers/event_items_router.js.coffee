class Agreatfirstdate.Routers.EventItemsRouter extends Backbone.Router
  initialize: (options) ->
    @me = options.me
    @user = options.user
    @pillars = options.pillars
    @pillar = @pillars.get(options.pillarId)
    @route("/pillars/#{@pillar.id}/event_items/:id", 'show')
    if @allowEdit = options.owner
      @route("/pillars/#{@pillar.id}/event_items/:id/edit", 'edit')
      @route("/pillars/#{@pillar.id}/event_items/new", 'newEventItem')

    @pillar.eventItems = new Agreatfirstdate.Collections.EventItemsCollection(null, pillar: @pillar, allowEdit: @allowEdit)
    @eventItems = @pillar.eventItems
    @eventItems.url = '/pillars/'+@pillar.id+'/event_items'
    @eventItems.reset options.eventItems

    _.bindAll(this, "fillEventTypes", "saveDialogForm", "updateDialogForm");
    @el = $("#event_items_popup")


  newEventItem: ->
    @el.dialog('destroy')
    @view = new Agreatfirstdate.Views.EventItems.NewView(collection: @eventItems, pillars: @pillars, pillarId: @pillar.id)
    @el.html(@view.render().el)
    @pillar.eventItems.currentModel = @view.model
    @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @view.model.eventPhotos, pillar: @pillar, eventItem: @view.model, facebook_token: @user.attributes.facebook_token, instagram_token: @user.attributes.instagram_token)
    @el.append(@photoView.render().el)

    @showDialog(@el, {
      title: "ADD AN EVENT",
      buttons: {
        "Create": @saveDialogForm
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

  show: (id) ->
    eventItem = @eventItems.get(id)

    @el.dialog('destroy')
    @showDialog @el,
      title: eventItem.eventType.get('title')
      open: =>
        @view = new Agreatfirstdate.Views.EventItems.ShowView(model: eventItem, collection: @eventItems, me: @me, user: @user)
        @view.render()

  edit: (id) ->
    @el.dialog('destroy')
    eventItem = @eventItems.get(id)
    @view = new Agreatfirstdate.Views.EventItems.EditView(model: eventItem, pillar: @pillar)
    @el.html(@view.render().el)
    @pillar.eventItems.currentModel = eventItem
    
    if (eventItem.attributes.event_type_has_attachments)
      @photoView = new Agreatfirstdate.Views.EventPhotos.NewView(collection: @view.model.eventPhotos, pillar: @pillar, eventItem: eventItem, facebook_token: @user.attributes.facebook_token, instagram_token: @user.attributes.instagram_token)
      @el.append(@photoView.render().el)
    
    @showDialog(@el, {
      title: "Edit Event",
      buttons: {
        "Save": @updateDialogForm
        "Cancel": -> $(this).dialog('close')
      }
    })
    
    if @view.model.eventPhotos.length > 0
      $('.event_photos_previews_').jcarousel
        scroll: 1

  showDialog: (el, options) ->
    el.dialog($.extend(
      {
        title: "aGreatFirstDate",
        height: 586,
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