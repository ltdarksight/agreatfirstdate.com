Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhotoView extends Backbone.View
  template : JST["backbone/user/photo/edit"]

  initialize: (options) ->
    super(options)
    @model.avatars.on 'reset', (collection)->
      @showPreviews collection
    , this

  showPreviews: (collection)->
    @$('.avatars_').empty()
    collection.each (avatar) ->
      view = new Agreatfirstdate.Views.User.EditPhotoPreviewView({model: avatar, user: @model})
      @$('.avatars_').append view.render().el
    , this

  update : (e) ->
    @$("form").submit()

  render : ->
    $(@el).html(@template(@model.toJSON()))
    @$('.form-wrapper_').html($('#profile_avatars_form').html())
    @showPreviews(@model.avatars)

    return this
