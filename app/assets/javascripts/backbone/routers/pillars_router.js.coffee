class Agreatfirstdate.Routers.PillarsRouter extends Backbone.Router
  places: ["#leftPillarContainer", "#leftMiddlePillar", "#rightMiddlePillar", "#rightPillar"]

  initialize: (options) ->
    @pillars = new Agreatfirstdate.Collections.PillarsCollection()
    @pillars.reset options.pillars
    _.each @pillars.models, (pillar, id) ->
      pillar.place = $(@places[id])
      pillar.eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter({pillars: @pillars, pillarId: pillar.id, eventItems: options.pillars[id].event_items})

    , this
    @index()

  routes:
    ".*": "index"

  index: ->
    _.each @pillars.models, (pillar, id) ->
      @view = new Agreatfirstdate.Views.Pillars.ShowView(model: pillar, id: "pillar_"+pillar.id)
      pillar.place.html(@view.render().el)
      pillar.eventItemsRouter.index()
    , this
