class Agreatfirstdate.Routers.EventItemsRouter extends Backbone.Router

  initialize: (options) ->
    @pillars = options.pillars
    @pillar = @pillars.at(options.index)
    @el = "#event_items_popup"

    @route("pillars/#{@pillar.id}/event_items/:id", 'show')
    @route("pillars/#{@pillar.id}/event_items/:id/edit", 'edit')
    @route("pillars/" + @pillar.id + "/event_items/new", 'newEventItem')

  newEventItem: ->
    view = new Agreatfirstdate.Views.EventItems.New(pillar: @pillar, pillars: @pillars)

  saveDialogForm: (e) ->
    @view.save(e)

  updateDialogForm: (e) ->
    @view.update(e)

  index: (parentView) ->
    view = new Agreatfirstdate.Views.EventItems.Index(
      pillar: @pillar
    )
    $(parentView.el).find('.pillar-content').html(view.render().el)

  show: (id) ->
    eventItem = @pillar.eventItems.get(id)
    view = new Agreatfirstdate.Views.EventItems.Show(
      model: eventItem
      pillar: @pillar
      pillars: @pillars
    )

  edit: (id) ->
    eventItem = @pillar.eventItems.get(id)
    $("#show_event_items_popup").modal("hide")
    view = new Agreatfirstdate.Views.EventItems.Edit(
      model: eventItem,
      pillar: @pillar,
      pillars: @pillars
    )

