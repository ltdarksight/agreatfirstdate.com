Agreatfirstdate.Views.Feedback ||= {}

class Agreatfirstdate.Views.Feedback.FormView extends Backbone.View
  template: JST["backbone/feedback/form"]

  initialize: (options)->
    @model = new Agreatfirstdate.Models.Feedback()
    @model.on 'change:errors', (model, errors)=>
      @$('span.error_').closest('.control-group').removeClass('error').end().remove()

      _.each errors, (errors, field)->
        $_input = @$(":input[name=#{field}]")
        $_input.after(@make("span", {class: "help-inline error_"}, _(errors).first()))
        $_input.closest('.control-group').addClass('error')
      , this

  confirmSend: ->
    if @model.isValid()
      $("#send_feedback_confirmation").dialog({
        resizable: false,
        height: 140,
        width: 500,
        modal: true,
        buttons:
          "Send Feedback": =>
            @send()
          Cancel: ->
            $(this).dialog("close")
      })
    return

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @$("form").backboneLink(@model)
    return this

  send: ->
    @model.unset('errors')
    @model.save(null,
      success : (user) =>
        $('#pageContainer').prepend(@make('div', {class: 'notice'}, 'Feedback has been sent!')).find('.notice').fadeOut(7000)
        $(@el).dialog('close')
      error: (model, data) =>
        @model.set('errors', $.parseJSON(data.responseText).errors)
    )
    $("#send_feedback_confirmation").dialog("close")

