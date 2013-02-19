Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditAbout extends Backbone.View
  template: JST["users/edit_about"]
  el: '#profile_popup'
  
  initialize: ->
    @who_am_i_ClassName = 'who_am_i'
    @model.on 'change:who_am_i', @render, this
  
  events:
    'click .save': 'submit'

  submit: ->
    @model.set 'who_am_i', $(@el).find("." + @who_am_i_ClassName).val()
    @model.sync('update', @model)
    $(@el).modal('hide')

  render: ->
    template = @template(who_am_i: @model.get('who_am_i'), className: @who_am_i_ClassName)
    
    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Who I Am'
      body: template
      el: @el
       
    $("#who_am_i").limit('500','#charsLeft')
    $("#who_am_i").focus()