Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditMeet extends Backbone.View
  template: JST["users/edit_meet"]

  initialize: ->
    @who_meet_ClassName = 'who_meet'
    @model.on 'change:who_meet', @render, this

  submit: ->
    @model.set 'who_meet', $(@el).find("." + @who_meet_ClassName).val()
    @model.sync('update', @model)

  render: ->
    $(@el).html @template(who_meet: @model.get('who_meet'), className: @who_meet_ClassName)
    this