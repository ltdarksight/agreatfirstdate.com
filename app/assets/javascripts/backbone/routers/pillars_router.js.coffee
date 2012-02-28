class Agreatfirstdate.Routers.PillarsRouter extends Backbone.Router
  initialize: (options) ->
    if @allowEdit = options.owner
      @route "/pillars/choose", "choose"
    @el = $("#event_items_popup")
    _.bindAll(this, "iAmReady", "initPillars");
    @pillarCategories = new Agreatfirstdate.Collections.PillarCategoriesCollection()
    @pillarCategories.reset options.pillarCategories
    @pillars = new Agreatfirstdate.Collections.PillarsCollection(allowEdit: @allowEdit)
    @initPillars(options.pillars)
    @userPillars = new Agreatfirstdate.Models.UserPillars(pillar_category_ids: @pillars.map (pillar)-> pillar.get('pillar_category_id'))
    @index()

  routes:
    "/index": "index"

  initPillars: (pillarsJson)->
    @places = {"#leftPillarContainer": null, "#leftMiddlePillar": null, "#rightMiddlePillar": null, "#rightPillar": null}
    @pillars.reset pillarsJson
    @pillars.each (pillar, id) ->
      setInterval pillar.photos.changeCurrent, 30*1000
      placeId = _.keys(@places)[id]
      pillar.place = $(placeId)
      @places[placeId] = pillar
      pillar.eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter({pillars: @pillars, pillarId: pillar.id, eventItems: pillarsJson[id].event_items, owner: @allowEdit})
    , this

  index: ->
    @el.empty().dialog('close')
    $("#profile_popup").dialog('close')
    _.each @places, (pillar, id) ->
      $(id).html(
        if pillar
          @view = new Agreatfirstdate.Views.Pillars.ShowView(model: pillar, id: "pillar_"+pillar.id)
          @view.render()
          pillar.eventItemsRouter.index(@view)
          @view.el
        else
          @view = new Agreatfirstdate.Views.Pillars.EmptyView(collection: @pillars)
          @view.render().el
      )
    , this

  choose: ->
    @view = new Agreatfirstdate.Views.Pillars.ChooseView(model: @userPillars, pillarCategories: @pillarCategories)
    @el.html(@view.render().el)
    @showDialog(@el, {
      buttons: {
        "I'm ready": @iAmReady,
        "Cancel": -> window.location.hash = "/index"
      },
      open: ->
        $(this).find('form .pillar_category_:first').trigger('change')
    })

  iAmReady: ->
    @view.save()

  showDialog: (el, options) ->
    el.dialog($.extend(
      {
        title: "aGreatFirstDate",
        height: 586,
        width: 868,
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