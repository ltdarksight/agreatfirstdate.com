class Agreatfirstdate.Routers.PillarsRouter extends Backbone.Router
  initialize: (options) ->
    @userRouter = options.userRouter
    @me = @userRouter.me
    @user = @userRouter.user

    if @allowEdit = options.owner
      @route "/pillars/choose", "choose"
    @el = $("#event_items_popup")
    _.bindAll(this, "iAmReady", "initPillars");
    @pillarCategories = new Agreatfirstdate.Collections.PillarCategoriesCollection()
    @pillarCategories.reset options.pillarCategories
    @pillars = new Agreatfirstdate.Collections.PillarsCollection(allowEdit: @allowEdit)
    @initPillars(options.pillars)
    @userPillars = new Agreatfirstdate.Models.UserPillars(pillars_attributes: @pillars.pillarsAttributes())
    @index()

  routes:
    "/index": "index"

  initPillars: (pillarsJson)->
    @places = {"#leftPillarContainer": null, "#leftMiddlePillar": null, "#rightMiddlePillar": null, "#rightPillar": null}
    @pillars.reset pillarsJson
    @pillars.each (pillar, id) ->
      placeId = _.keys(@places)[id]
      pillar.place = $(placeId)
      @places[placeId] = pillar
      pillar.eventItemsRouter = new Agreatfirstdate.Routers.EventItemsRouter({pillars: @pillars, pillarId: pillar.id, eventItems: pillarsJson[id].event_items, owner: @allowEdit, me: @me, user: @user})
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
    window.userRouter.user.fetchPoints()

  choose: ->
    @view = new Agreatfirstdate.Views.Pillars.ChooseView(model: @userPillars, pillarCategories: @pillarCategories, pillars: @pillars)
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
