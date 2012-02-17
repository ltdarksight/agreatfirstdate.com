Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditAboutView extends Backbone.View
  template : JST["backbone/user/edit_about"]

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (user) =>
        @model = user
        window.location.hash = "/index"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    @$("form").backboneLink(@model)
    return this
