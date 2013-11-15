Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EmailView extends Backbone.View
  template : JST["users/send_email"]
  events:
    "hidden": 'handleCloseSubwindow'
    "click .btn.save": 'handleSend'
    'focus input, textarea' : 'handleInputFocus'


  initialize: (options)->
    _.bindAll @, "handleCloseSubwindow"
    _.bindAll @, "handleSend"
    @sender = options.sender
    @recipient = options.recipient

    @model = new Agreatfirstdate.Models.Email recipient_id: @recipient.get('id')

    @model.on 'invalid', @showError, @
    @model.on 'error', @serverError, @

  serverError: (model, response, options) ->
    _errors = JSON.parse(response.responseText)
    @showError(model, _errors.errors)

  showError: (model, errors) ->
    _.each errors, (_errors, field) ->
      _input = @$("[name=#{field}]")
      _input.after($("<span/>", {class: 'help-inline error_', text: _(_errors).first() } ))
      _input.closest('.control-group').addClass('error')


  handleInputFocus: (event)->
    $(event.target).addClass("touched")

  handleCloseSubwindow: ->
    @.options.parent.trigger "subwindow:close" if @.options.parent

  handleSend: ->
    @$('.error_').remove()
    @$('.control-group.error').removeClass('error')
    _gaq.push ["_trackPageview", "Say Hi Sent"]
    attr = {
      body: @$("#body").val(),
      subject: @$("#subject").val()
      }
    @model.save attr,
      success: (model) =>
        @modal.hide()
        $($('<div/>', {class: 'alert alert-success', text: 'Your message has been sent!'})).prependTo($('.container .row .span12')).delay(5000).slideUp(2000)

  render : ->
    template = @template
      sender: @sender.toJSON(false)
      recipient: @recipient.toJSON(false)

    @modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Say Hi'
      body: template
      el: @el
      view: @
      saveText: 'Send'

    @
