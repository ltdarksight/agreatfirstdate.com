Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.About extends Backbone.View
  className: 'pillar-content'
  template: JST['users/about']

  events:
    'click .btn.to_activate' : 'activate'
    'click .btn.to_deactivate' : 'deactivate'

  initialize: ->
    @model.on 'change:who_am_i', @render, @
    @model.on 'change:status', @render, @

    @me  = Agreatfirstdate.currentProfile

  activate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.activate
      success: (user, response)=>
        @model.set('status', response.status)

  stillInappropriate: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.sync 'still_inappropriate', @model, success: (user)=>
      @inappropriateContent.set(user.inappropriate_content)

  deactivate: (e)->
    e.preventDefault()
    e.stopPropagation()
    if  $('#deactivateView').length == 0
      $('body').append($("<div/>", {id: 'deactivateView', class: 'modal hide fade'}))

    @deactivateView = new Agreatfirstdate.Views.User.Deactivate
      me: @me
      model: @model

    @deactivateView.render()

  render: ->
    $(@el).html(@template(profile: @model, me: @me))
    @
