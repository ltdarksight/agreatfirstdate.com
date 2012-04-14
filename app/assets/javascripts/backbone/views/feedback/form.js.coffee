Agreatfirstdate.Views.Feedback ||= {}

class Agreatfirstdate.Views.Feedback.FormView extends Backbone.View
  template: JST["backbone/feedback/form"]

  initialize: (options)->
    @model = new Agreatfirstdate.Models.Feedback()
    @model.on 'change:errors', (model, errors)=>
      @$('span.error_').closest('.control-group').removeClass('error').end().remove()

      _.each errors, (errors, field)->
        $_input = @$(".touched:input[name=#{field}]")
        $_input.after(@make("span", {class: "help-inline error_"}, _(errors).first()))
        $_input.closest('.control-group').addClass('error')
      , this

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @$("form").backboneLink(@model)

    @any_input = @$("form").find("input, textarea")
    @any_input.focus -> $(this).addClass("touched")

    return this

  send: ->
    @model.unset('errors')
    @any_input.addClass("touched")
    @model.save(null,
      success : (user) =>
        $('#pageContainer').prepend(@make('div', {class: 'notice'}, 'Feedback has been sent!')).find('.notice').fadeOut(7000)
        $(@el).dialog('close')
      error: (model, data) =>
        @model.set('errors', $.parseJSON(data.responseText).errors)
    )
