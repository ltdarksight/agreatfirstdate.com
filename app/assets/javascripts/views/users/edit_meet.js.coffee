Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditMeet extends Backbone.View
  template: JST["users/edit_meet"]
  el: '#profile_popup'

  initialize: ->
    @who_meet_ClassName = 'who_meet'
    @model.on 'change:who_meet', @render, this
    
  events:
    'click .save': 'submit'

  submit: ->
    @model.set 'who_meet', $(@el).find("." + @who_meet_ClassName).val()
    @model.sync('update', @model)
    $(@el).modal('hide')

  render: ->
    template =  @template(who_meet: @model.get('who_meet'), className: @who_meet_ClassName)
      
    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Who would you like to find?'
      body: template
      el: @el
    
    $("#who_meet").limit('500','#charsLeft');
    $("#who_meet").focus()