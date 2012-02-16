class Agreatfirstdate.Routers.PillarsRouter extends Backbone.Router
  initialize: (options) ->
    @el = $("#event_items_popup")
    @pillarCategories = new Agreatfirstdate.Collections.PillarCategoriesCollection()
    @pillarCategories.reset options.pillarCategories
    @pillars = new Agreatfirstdate.Collections.PillarsCollection()
    @initPillars(options.pillars)
    @userPillars = new Agreatfirstdate.Models.UserPillars(pillar_category_ids: @pillars.map (pillar)-> pillar.get('pillar_category_id'))
    _.bindAll(this, "iAmReady");
    @index()

  routes:
    ".*": "index"
    "/pillars/choose": "choose"

  initPillars: (pillarsJson)->
    @places = {"#leftPillarContainer": null, "#leftMiddlePillar": null, "#rightMiddlePillar": null, "#rightPillar": null}
    @pillars.reset pillarsJson
    @pillars.each (pillar, id) ->
      placeId = _.keys(@places)[id]
      pillar.place = $(placeId)
      @places[placeId] = pillar
      pillar.eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter({pillars: @pillars, pillarId: pillar.id, eventItems: pillarsJson[id].event_items})
    , this

  index: ->
    _.each @places, (pillar, id) ->
      $(id).html(
        if pillar
          @view = new Agreatfirstdate.Views.Pillars.ShowView(model: pillar, id: "pillar_"+pillar.id)
          @view.render()
          pillar.eventItemsRouter.index(@view)
          @view.el
        else
          @view = new Agreatfirstdate.Views.Pillars.EmptyView()
          @view.render().el
      )
    , this

  choose: ->
    @view = new Agreatfirstdate.Views.Pillars.ChooseView(model: @userPillars, pillarCategories: @pillarCategories)
    @el.html(@view.render().el)
    @showDialog(@el, {
      buttons: {
        "I'm ready": @iAmReady,
        "Cancel": -> window.location.hash = ""
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
        height: 486,
        width: 960,
        resizable: false,
        draggable: false,
        modal: true,
        buttons: {
          "Close": -> window.location.hash = ""
        }
      }, options)
    )