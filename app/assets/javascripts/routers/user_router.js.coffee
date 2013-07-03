class Agreatfirstdate.Routers.UserRouter extends Backbone.Router

  initialize: (options) ->

    @collection = new Agreatfirstdate.Collections.Profiles()
    @profile = new Agreatfirstdate.Models.Profile(options.profile, {collection: @collection})
    @me  = Agreatfirstdate.currentProfile

    @route "profile/who_am_i/edit", "editAbout"
    @route "profile/who_meet/edit", "editMeet"
    @route "profile/photo/edit", "editPhoto"
    @route "say_hi", "sayHi"

    @el = $("#profile_popup")

    @show()

    _.bindAll @, "updateDialogForm"
    _.bindAll @, "sayHi"

    @user = new Agreatfirstdate.Models.User($.extend(options.user, allowEdit: @me))


    #if @allowEdit = options.owner
    #  @route "profile/who_am_i/edit", "editAbout"
    #  @route "profile/who_meet/edit", "editMeet"
    #  @route "profile/photo/edit", "editPhoto"

    #  @me = @user
    #else
    #  @me = new Agreatfirstdate.Models.User(options.me)
    #  @route "/say_hi", "sayHi"
    #
    # setInterval @me.fetchPoints, 30*1000
    #
    # @el = $("#profile_popup")
    # _.bindAll(this, "updateDialogForm", "cropImage");

  sayHi: ->

    if @me.get('points') >= 100

      @email_form = new Agreatfirstdate.Views.User.EmailView
        sender: @me
        recipient: @profile
        el: $("#email_popup")

      @email_form.render()

    else

      @modalDialog = new Agreatfirstdate.Views.Application.Modal
        header: 'aGreatFirstDate -'
        url: '/welcome/faq.js#get_more_points'
        el: $("#not_enough_points_popup")
        view: @
        allowSave: false

  show: ->
    aboutView = new Agreatfirstdate.Views.User.About(model: @profile)
    $('#pillarAboutMeContent').html(aboutView.render().el)
    meetView = new Agreatfirstdate.Views.User.Meet(model: @profile)
    $('#pillarAboutMeMeet').html(meetView.render().el)

    photoView = new Agreatfirstdate.Views.User.Photo
      model: @profile
      el: $('#pillarAboutMePhoto')

    photoView.render()

    new Agreatfirstdate.Views.User.PointsView(model: @profile)
    # if @allowEdit
    #   statusView = new Agreatfirstdate.Views.User.StatusView(model: @user).render()

  settings: (options)->
    user = new Agreatfirstdate.Models.UserSettings(options);
    formView = new Agreatfirstdate.Views.User.Settings.FormView({user: user});
    formView.render();

  editAbout: ->
    ea = new Agreatfirstdate.Views.User.EditAbout(model: @profile)
    ea.render()

  editMeet: ->
    em = new Agreatfirstdate.Views.User.EditMeet(model: @profile)
    em.render()

  editPhoto: ->
    ep = new Agreatfirstdate.Views.User.EditPhoto(model: @profile)

  updateDialogForm: (e) ->
    @view.update(e)

  cropImage: (e) ->
    $(@view.el).find('a.crop_').trigger('click')
