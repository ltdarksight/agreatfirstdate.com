class Agreatfirstdate.Routers.UserRouter extends Backbone.Router
  
  initialize: (options) ->

    @collection = new Agreatfirstdate.Collections.Profiles()
    @profile = new Agreatfirstdate.Models.Profile(options.profile, {collection: @collection})
    
    @route "profile/who_am_i/edit", "editAbout"
    @route "profile/who_meet/edit", "editMeet"
    @route "profile/photo/edit", "editPhoto"
    
    @el = $("#profile_popup")
    
    @show()
    
    _.bindAll(this, "updateDialogForm");
    
    # @user = new Agreatfirstdate.Models.User($.extend(options.user, allowEdit: options.owner))
    # if @allowEdit = options.owner
    #   @route "profile/who_am_i/edit", "editAbout"
    #   @route "profile/who_meet/edit", "editMeet"
    #   @route "profile/photo/edit", "editPhoto"
    # 
    #   @me = @user
    # else
    #   @me = new Agreatfirstdate.Models.User(options.me)
    #   @route "/say_hi", "sayHi"
    # 
    # setInterval @me.fetchPoints, 30*1000
    # 
    # @el = $("#profile_popup")
    # _.bindAll(this, "updateDialogForm", "cropImage");

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
    aboutView = new Agreatfirstdate.Views.User.About(model: @profile)
    $('#pillarAboutMeContent').html(aboutView.render().el)
    meetView = new Agreatfirstdate.Views.User.Meet(model: @profile)
    $('#pillarAboutMeMeet').html(meetView.render().el)
    photoView = new Agreatfirstdate.Views.User.Photo(model: @profile)
    $('#pillarAboutMePhoto').html(photoView.render().el)
    # pointsView = new Agreatfirstdate.Views.User.PointsView(model: @me).render()
    # if @allowEdit
    #   statusView = new Agreatfirstdate.Views.User.StatusView(model: @user).render()

  settings: (options)->
    user = new Agreatfirstdate.Models.UserSettings(options);
    formView = new Agreatfirstdate.Views.User.Settings.FormView({user: user});
    formView.render();

  editAbout: ->
    ea = new Agreatfirstdate.Views.User.EditAbout(model: @profile)
    @el.html(ea.render().el)
    @showDialog(@el, {
      title: "Who Am I",
      height: 300,
      buttons: {
        "Submit": -> 
          ea.submit()
          $(this).dialog('close')
        "Cancel": -> $(this).dialog('close')
      }
    })
    $("#who_am_i").limit('500','.ui-dialog #charsLeft')
    $("#who_am_i").focus()

  editMeet: ->
    em = new Agreatfirstdate.Views.User.EditMeet(model: @profile)
    @el.html(em.render().el)
    @showDialog(@el, {
      title: "Who I'd like to meet",
      height: 300,
      buttons: {
        "Submit": -> 
          em.submit()
          $(this).dialog('close')
        "Cancel": -> $(this).dialog('close')
      }
    })
    $("#who_meet").limit('500','.ui-dialog #charsLeft');
    $("#who_meet").focus()

  editPhoto: ->
    ep = new Agreatfirstdate.Views.User.EditPhoto(model: @profile)
    @el.html(ep.render().el)
    @showDialog(@el, {
      width: 705,
      buttons:
        "Save and Close": -> $(this).dialog('close')
    })

  updateDialogForm: (e) ->
    @view.update(e)

  cropImage: (e) ->
    $(@view.el).find('a.crop_').trigger('click')

  showDialog: (el, options) ->
    el.dialog($.extend(
      {
        title: "aGreatFirstDate - Profile",
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