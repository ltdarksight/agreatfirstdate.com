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

    #@route "pillars/choose", "choose"

    @el = '#event_items_popup'

    @renderPillars()

    @pillars.on 'reset', @renderPillars, @

    # @userRouter = options.userRouter
    # @me = @userRouter.me
    # @user = @userRouter.user
    #
    # if @allowEdit = options.owner
    #   @route "/pillars/choose", "choose"
    # @el = $("#event_items_popup")
    # _.bindAll(this, "iAmReady", "initPillars");
    # @pillarCategories = new Agreatfirstdate.Collections.PillarCategoriesCollection()
    # @pillarCategories.reset options.pillarCategories
    # @pillars = new Agreatfirstdate.Collections.PillarsCollection(allowEdit: @allowEdit)
    # @initPillars(options.pillars)
    # @userPillars = new Agreatfirstdate.Models.UserPillar selected_pillar_ids: @pillars.pillarIds()
    # @index()

  # initPillars: (pillarsJson)->
  #   @places = {"#leftPillarContainer": null, "#leftMiddlePillar": null, "#rightMiddlePillar": null, "#rightPillar": null}
  #   @pillars.reset pillarsJson
  #   @pillars.each (pillar, id) ->
  #     placeId = _.keys(@places)[id]
  #     pillar.place = $(placeId)
  #     @places[placeId] = pillar
  #     pillar.eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter({pillars: @pillars, pillarId: pillar.id, eventItems: pillarsJson[id].event_items, owner: @allowEdit, me: @me, user: @user})
  #   , this

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
    , this

  # index: ->
    # ->
    #   @el.empty().dialog('close')
    #   $("#profile_popup").dialog('close')
    # _.each @places, (pillar, id) ->
    #   $(id).html(
    #     if pillar
    #       @view = new Agreatfirstdate.Views.Pillars.ShowView(model: pillar, id: "pillar_"+pillar.id)
    #       @view.render()
    #       pillar.eventItemsRouter.index(@view)
    #       @view.el
    #     else
    #       @view = new Agreatfirstdate.Views.Pillars.EmptyView(collection: @pillars)
    #       @view.render().el
    #   )
    # , this
    # window.userRouter.user.fetchPoints()

  choose: ->
    view = new Agreatfirstdate.Views.Pillars.Choose
      pillarCategories: @pillarCategories
      pillars: @pillars
      profile: @profile
