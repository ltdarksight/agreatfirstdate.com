Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditAboutView extends Backbone.View
  template : JST["users/edit_about"]

  initialize: (options)->
    super options
    @model.on 'error', (model, response)->
      console.log response.responseText

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    @model.set('who_am_i', @$('#who_am_i').val(), silent: true)
    @model.unset 'errors'
    @model.save(null,
      success : (user) ->
        @model = user
        window.location.hash = "/index"
    )

  render : ->
    $(@el).html(@template(@model.toJSON(false)))
    return this