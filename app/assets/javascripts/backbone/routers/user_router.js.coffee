class Agreatfirstdate.Routers.UserRouter extends Backbone.Router
  initialize: (options) ->
    @user = new Agreatfirstdate.Models.User($.extend(options.user, allowEdit: options.owner))
    if @allowEdit = options.owner
      @route "/profile/who_am_i/edit", "editAbout"
      @route "/profile/who_meet/edit", "editMeet"
      @route "/profile/photo/edit", "editPhoto"

      @me = @user
    else
      @me = new Agreatfirstdate.Models.User(options.me)
      @route "/say_hi", "sayHi"

    setInterval @me.fetchPoints, 30*1000

    @el = $("#profile_popup")
    _.bindAll(this, "updateDialogForm", "cropImage");
    
  sayHi: ->
    if @me.get('points') >= 100
      @view = new Agreatfirstdate.Views.User.EmailView(sender: @me, recipient: @user)
      @el.html(@view.render().el)
      @showDialog(@el, {
        height: 400,
        buttons: {
          "Send": => @view.confirmSend()
          "Cancel": -> $(this).dialog('close')
        }
      })
    else
      @showDialog $("#not_enough_points_popup"),
        height: 130
        width: 400
        buttons:
          "Get More Points": -> location.href = '/welcome/faq#get_more_points'
          "Cancel": -> $(this).dialog('close')

  show: ->
    aboutView = new Agreatfirstdate.Views.User.AboutView(model: @user, me: @me)
    $('#pillarAboutMeContent').html(aboutView.render().el)
    meetView = new Agreatfirstdate.Views.User.MeetView(model: @user)
    $('#pillarAboutMeMeet').html(meetView.render().el)
    photoView = new Agreatfirstdate.Views.User.PhotoView(model: @user)
    $('#pillarAboutMePhoto').html(photoView.render().el)
    pointsView = new Agreatfirstdate.Views.User.PointsView(model: @me).render()
    if @allowEdit
      statusView = new Agreatfirstdate.Views.User.StatusView(model: @user).render()

  settings: (options)->
    user = new Agreatfirstdate.Models.UserSettings(options);
    formView = new Agreatfirstdate.Views.User.Settings.FormView({user: user});
    formView.render();

  editAbout: (id) ->
    @view = new Agreatfirstdate.Views.User.EditAboutView(model: @user)
    @el.html(@view.render().el)
    @showDialog(@el, {
      title: "Who Am I",
      height: 300,
      buttons: {
        "Submit": @updateDialogForm
        "Cancel": -> $(this).dialog('close')
      }
    })
    $("#who_am_i").limit('500','.ui-dialog #charsLeft')
    $("#who_am_i").focus()

  editMeet: (id) ->
    @view = new Agreatfirstdate.Views.User.EditMeetView(model: @user)
    @el.html(@view.render().el)
    @showDialog(@el, {
      title: "Who I'd like to meet",
      height: 300,
      buttons: {
        "Submit": @updateDialogForm
        "Cancel": -> $(this).dialog('close')
      }
    })
    $("#who_meet").limit('500','.ui-dialog #charsLeft');
    $("#who_meet").focus()

  editPhoto: (id) ->
    @view = new Agreatfirstdate.Views.User.EditPhotoView(model: @user)
    @el.html(@view.render().el)
    @showDialog(@el, {
      title: "Upload Some Pics",
      buttons: {
      }
    })

  updateDialogForm: (e) ->
    @view.update(e)

  cropImage: (e) ->
    $(@view.el).find('a.crop_').trigger('click')

  showDialog: (el, options) ->
    el.dialog($.extend(
      {
        title: "aGreatFirstDate - Profile",
        height: 656,
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
