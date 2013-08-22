class Agreatfirstdate.Routers.PillarsRouter extends Backbone.Router
  routes:
    "pillars/choose": "choose"

  initialize: (options) ->
    @pillarCategories = new Agreatfirstdate.Collections.PillarCategories(
      options.pillarCategories
    )
    @pillars = new Agreatfirstdate.Collections.Pillars(
      options.pillars
    )
    @profile = options.profile
    @places =
      "#leftPillarContainer": null
      "#leftMiddlePillar": null
      "#rightMiddlePillar": null
      "#rightPillar": null

    @el = '#event_items_popup'

    @renderPillars()

    @pillars.on 'reset', @renderPillars, @


  renderPillars: ->
    i = 0
    _.each @places, (pillar, id) ->
      if @pillars.at(i)
        view = new Agreatfirstdate.Views.Pillars.Show(model: @pillars.at(i))
      else
        view = new Agreatfirstdate.Views.Pillars.Empty

      $(id).html view.render().el

      if @pillars.at(i)
        @pillars.at(i).eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter(pillars: @pillars, index: i)
        @pillars.at(i).eventItemsRouter.index(view)

      i++
    , @

    $('.carousel-pillar_photos .carousel').jcarousel(
      wrap: 'circular'
    ).jcarouselAutoscroll(
      interval: 10000
    )

    @

  choose: ->
    view = new Agreatfirstdate.Views.Pillars.Choose
      pillarCategories: @pillarCategories
      pillars: @pillars
      profile: @profile
