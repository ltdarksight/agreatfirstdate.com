Agreatfirstdate.Views.Application ||= {}

class Agreatfirstdate.Views.Application.Spinner extends Backbone.View
  show: ->
    @billingSpinner = new Agreatfirstdate.Views.Application.Notification
      header: 'Please wait'
      allowClose: false
      spinner: true
      body: ''

  hide: ->
    $('#popup-notification').modal 'hide'
