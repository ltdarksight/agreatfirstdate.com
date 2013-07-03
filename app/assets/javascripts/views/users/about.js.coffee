Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.About extends Backbone.View
  className: 'pillar-content'
  template: JST['users/about']

  initialize: ->
    @model.on('change:who_am_i', @render, this)
    @me  = Agreatfirstdate.currentProfile
    # super(options)
    # @me = options.me
    # @template = JST["users/about#{if @model.allowEdit then '' else '_guest'}"]
    # @model.on 'change:who_am_i', @render, this
    # @inappropriateContent = @model.inappropriateContent
    # if @me.is('admin')
    #   @model.on 'change:status', @render, this
    #   @inappropriateContent.on 'change:status', @render, this
    #   @delegateEvents
    #     'click .activate_': 'activate'
    #     'click .deactivate_': 'deactivate'
    #     'click .still-inappropriate_': 'stillInappropriate'

  activate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.sync 'activate', @model, success: (user)=>
      @model.set('status', user.status)

  stillInappropriate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.sync 'still_inappropriate', @model, success: (user)=>
      @inappropriateContent.set(user.inappropriate_content)

  deactivate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @deactivateView = new Agreatfirstdate.Views.Shared.DeactivateView(me: @me, model: @model)

    $(@deactivateView.render().el).dialog
      height: 200
      width: 640
      resizable: false
      draggable: false
      modal: true,
      buttons:
        "Deactivate": =>
          @deactivateView.update()
          $(@deactivateView.el).dialog('close')

        "Cancel": -> $(this).dialog('close')

  render: ->
    # $(@el).html(@template($.extend(@model.toJSON(false), {me: @me.toJSON(false), inappropriateContent: @inappropriateContent.toJSON()})))
    $(@el).html(@template(about: @model))
    @
