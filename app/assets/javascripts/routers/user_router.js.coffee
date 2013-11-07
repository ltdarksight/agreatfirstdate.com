class Agreatfirstdate.Routers.UserRouter extends Backbone.Router

  routes:
    "profile/photo/edit" : "editPhoto"
    "say_hi" : "sayHi"
    "profile/who_am_i/edit" : "editAbout"
    "profile/who_meet/edit" : "editMeet"

  initialize: (options) ->

    @collection = new Agreatfirstdate.Collections.Profiles()
    @profile = new Agreatfirstdate.Models.Profile(options.profile, {collection: @collection})
    @me  = Agreatfirstdate.currentProfile

    @el = $("#profile_popup")

    @show()

    _.bindAll @, "updateDialogForm"
    _.bindAll @, "sayHi"

    @user = new Agreatfirstdate.Models.User($.extend(options.user, allowEdit: @me))

    @
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

    if !@me.get('stripe_customer_token')
      header = 'Complete Profile'
      body = "It's free to browse, but anything great requires a little investment. Become a member by adding your billing information on the settings page."
      saveText = 'Settings'
      saveHref = '/me/edit#billing'

      new Agreatfirstdate.Views.Application.Notification
        header: header
        body: body
        allowSave: true
        saveText: saveText
        saveHref: saveHref

    else if @me.get('points') >= 100

      @email_form = new Agreatfirstdate.Views.User.EmailView
        sender: @me
        recipient: @profile
        el: $("#email_popup")

      @email_form.render()

    else

      @modalDialog = new Agreatfirstdate.Views.Application.Modal
        header: 'A Great! First Date'
        el: $("#not_enough_points_popup")
        view: @
        body: JST["users/send_email_error"]()
        allowSave: false
        typeClose: 'button'

  show: ->
    aboutView = new Agreatfirstdate.Views.User.About(model: @profile)
    $('#pillarAboutMeContent').html(aboutView.render().el)
    meetView = new Agreatfirstdate.Views.User.Meet(model: @profile)
    $('#pillarAboutMeMeet').html(meetView.render().el)

    photoView = new Agreatfirstdate.Views.User.Photo
      model: @profile
      el: $('#pillarAboutMePhoto')

    photoView.render()

    new Agreatfirstdate.Views.User.PointsView(model: @me)
    # if @allowEdit
    #   statusView = new Agreatfirstdate.Views.User.StatusView(model: @user).render()

  settings: (options)->
    user = new Agreatfirstdate.Models.UserSettings(options)
    formView = new Agreatfirstdate.Views.User.Settings.FormView({user: user})
    formView.render()

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
