Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.CancelAccountView extends Backbone.View
  className: 'modal fade'
  template: JST['users/cancel_account']

  events:
    "show" : 'handleShown'

  initialize: ->
    @paramName = $("meta[name='csrf-param']").attr('content');
    @paramValue = $("meta[name='csrf-token']").attr('content');
    @render()


  handleShown: (event) ->
    @.$el.css
      'margin-top':  window.pageYOffset

  render: ->
    @.$el.css
      'margin-top':  window.pageYOffset

    @$el.html @template
      paramName: @paramName
      paramValue: @paramValue

    @$el.modal('show')
    @
