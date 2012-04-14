class Agreatfirstdate.Models.Feedback extends Backbone.Model
  paramRoot: 'feedback'

  defaults:
    email: ''
    subject: ''
    body: ''

  initialize: (options)->
    @url = "/welcome/send_feedback"

  validate: (attrs)->
    @unset 'errors', silent: true

    @validateEmail(attrs, 'email')
    @validatePresenceOf(attrs, 'email')
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

  validateEmail: (attrs, attr)->
    errors = {}
    unless attrs[attr].match /^[^@]+@([^@\.]+\.)+[^@\.]+$/
      errors[attr] = ["has wrong format"]
      @set 'errors', $.extend(@get('errors'), errors), {silent: true}
    @set(attr, attrs[attr], silent: true)
