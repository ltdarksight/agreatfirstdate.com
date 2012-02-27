class Agreatfirstdate.Models.Email extends Backbone.Model
  paramRoot: 'email'

  defaults:
    recipient_id: null
    subject: ''
    body: ''

  initialize: (options)->
    @sender = options.sender
    @recipient = options.recipient
    @url = "/profiles/#{@recipient.id}/send_email"

  validate: (attrs)->
    console.log subject = attrs.subject
    console.log body = attrs.body
    null
    @set('errors', {subject: "can't be blank"})
    null