class Agreatfirstdate.Models.Feedback extends Backbone.Model
  paramRoot: 'feedback'

  defaults:
    subject: ''
    body: ''

  initialize: (options)->
    @url = "/welcome/send_feedback"

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