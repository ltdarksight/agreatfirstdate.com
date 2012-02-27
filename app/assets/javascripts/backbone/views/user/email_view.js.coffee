Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EmailView extends Backbone.View
  template : JST["backbone/user/send_email"]

  initialize: (options)->
    @model = new Agreatfirstdate.Models.Email(sender: options.sender, recipient: options.recipient)
    @model.on 'error', (model, data)=>
      response = $.parseJSON(data.responseText)
      _.each response.errors, (errors, field)->
        $_input = @$(":input[name=#{field}]")
        $_input.after(@make("span", {class: "help-inline error_"}, _(errors).first()))
        $_input.closest('.control-group').addClass('error')
      , this

  send : (e) ->
    console.log $("#send_message_confirmation").dialog({
		  resizable: false,
		  height: 140,
		  width: 500,
		  modal: true,
		  buttons:
		    "Send Message": =>
		      @$('span.error_').closest('.control-group').removeClass('error').end().remove()
		      @model.save(null,
            success : (user) =>
              @model.sender.set('points', user.get('points'))
              window.location.hash = "/index"
              $('#pageContainer').prepend(@make('div', {class: 'notice'}, 'Your message has been sent!')).find('.notice').fadeOut(7000)
          )
		      $("#send_message_confirmation").dialog("close")
		    Cancel: ->
          $(this).dialog("close")
    })
    return



  render : ->
    $(@el).html(@template(sender: @model.sender.toJSON(false), recipient: @model.recipient.toJSON(false)))
    @$("form").backboneLink(@model)
    return this
