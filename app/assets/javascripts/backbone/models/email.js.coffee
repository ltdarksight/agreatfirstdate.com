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
    @unset 'errors', silent: true

    @validatePresenceOf(attrs, 'subject')
    @validatePresenceOf(attrs, 'body')

    @trigger('change:errors', this, @get('errors'))
    @get 'errors'

  validatePresenceOf: (attrs, attr)->
    errors = {}
    if attrs[attr] == ''
      errors[attr] = ["can't be blank"]
      @set 'errors', $.extend(@get('errors'), errors), {silent: true}
    @set(attr, attrs[attr], silent: true)