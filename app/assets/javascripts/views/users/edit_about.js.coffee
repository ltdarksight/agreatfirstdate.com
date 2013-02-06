Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditAbout extends Backbone.View
  template: JST["users/edit_about"]
  
  initialize: ->
    @who_am_i_ClassName = 'who_am_i'
    @model.on 'change:who_am_i', @render, this

  submit: ->
    @model.set 'who_am_i', $(@el).find("." + @who_am_i_ClassName).val()
    @model.sync('update', @model)

  render: ->
    $(@el).html(@template(who_am_i: @model.get('who_am_i'), className: @who_am_i_ClassName))
    this