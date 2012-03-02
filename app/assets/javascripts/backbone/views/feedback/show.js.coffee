Agreatfirstdate.Views.Feedback ||= {}

class Agreatfirstdate.Views.Feedback.ShowView extends Backbone.View
  initialize: (options)->
    @setElement($('#feedback'))

  events:
    'click': 'showForm'

  showForm: (e)->
    e.preventDefault()
    e.stopPropagation()
    @view = new Agreatfirstdate.Views.Feedback.FormView()
    $(@view.render().el).dialog
      height: 300
      width: 640
      resizable: false
      draggable: false
      modal: true,
      buttons:
        "Send": =>
          @view.confirmSend()

        "Cancel": -> $(this).dialog('close')
