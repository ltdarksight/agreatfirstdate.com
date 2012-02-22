class Agreatfirstdate.Routers.UserRouter extends Backbone.Router
  initialize: (options) ->
    if @allowEdit = options.owner
      @route "/profile/who_am_i/edit", "editAbout"
      @route "/profile/who_meet/edit", "editMeet"
      @route "/profile/photo/edit", "editPhoto"

    @user = new Agreatfirstdate.Models.User($.extend(options.user, allowEdit: @allowEdit))
    @el = $("#profile_popup")
    _.bindAll(this, "updateDialogForm", "cropImage");

  show: ->
    aboutView = new Agreatfirstdate.Views.User.AboutView(model: @user)
    $('#pillarAboutMeContent').html(aboutView.render().el)
    meetView = new Agreatfirstdate.Views.User.MeetView(model: @user)
    $('#pillarAboutMeMeet').html(meetView.render().el)
    photoView = new Agreatfirstdate.Views.User.PhotoView(model: @user)
    $('#pillarAboutMePhoto').html(photoView.render().el)

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
        "Crop": @cropImage
        "Close": -> $(this).dialog('close')
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