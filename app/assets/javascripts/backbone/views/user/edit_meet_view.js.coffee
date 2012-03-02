Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditMeetView extends Backbone.View
  template : JST["backbone/user/edit_meet"]

  initialize: (options)->
    super options
    @model.on 'error', (model, response)->
      console.log response.responseText

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.set('who_meet', @$('#who_meet').val(), silent: true)
    @model.save(null,
      success : (user) =>
        @model = user
        window.location.hash = "/index"
    )

  render : ->
    $(@el).html @template(@model.toJSON(false))
    return this
