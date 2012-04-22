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
      height: 340
      width: 640
      resizable: true
      draggable: false
      modal: true,
      buttons:
        "Send": =>
          @view.send()

        "Cancel": -> $(this).dialog('close')
      resizeStop: =>
        form = @view.$("form")
        body_area = form.find("#body")
        body_area.height(body_area.height() + form.parent().height() - form.height())
