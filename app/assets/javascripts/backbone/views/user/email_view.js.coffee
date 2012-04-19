Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EmailView extends Backbone.View
  template : JST["backbone/user/send_email"]

  initialize: (options)->
    @model = new Agreatfirstdate.Models.Email(sender: options.sender, recipient: options.recipient)
    @model.on 'change:errors', (model, errors)=>
      @$('span.error_').closest('.control-group').removeClass('error').end().remove()

      _.each errors, (errors, field)->
        $_input = @$(".touched:input[name=#{field}]")
        $_input.after(@make("span", {class: "help-inline error_"}, _(errors).first()))
        $_input.closest('.control-group').addClass('error')
      , this

  confirmSend: ->
    if @model.isValid()
      @send()
    false

  send: ->

    @model.unset('errors')
    @any_input.addClass("touched")
    @model.save(null,
      success : (user) =>
        @model.sender.set('points', user.get('points'))
        window.location.hash = "/index"
        $(@make('div', {class: 'alert alert-success span4 offset8'}, 'Your message has been sent!')).prependTo($('#pageContainer')).delay(5000).slideUp(2000)
      error: (model, data) =>
        @model.set('errors', $.parseJSON(data.responseText).errors)
    )

  render : ->
    $(@el).html(@template(sender: @model.sender.toJSON(false), recipient: @model.recipient.toJSON(false)))
    @$("form").backboneLink(@model)

    @any_input = @$("form").find("input, textarea")
    @any_input.focus -> $(this).addClass("touched")

    return this
