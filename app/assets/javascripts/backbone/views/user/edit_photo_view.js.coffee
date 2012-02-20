Agreatfirstdate.Views.User ||= {}

class Agreatfirstdate.Views.User.EditPhotoView extends Backbone.View
  template : JST["backbone/user/photo/edit"]
  className: 'edit-photos_'

  initialize: (options) ->
    super(options)
    @model.avatars.on 'reset', (collection)->
      @render()
    , this

    @model.on('error', (model, errors) ->
      _.each errors['avatars.image'], (error)->
        @$("form .errors_").append error
    , this)

  showPreviews: (collection)->
    @$('.avatars_, .large_').empty()
    collection.each (avatar, id) ->
      view = new Agreatfirstdate.Views.User.EditPhotoPreviewView({model: avatar, user: @model})
      @$('.avatars_').append view.render().el
      view.showLarge() if 0 == id
    , this

  update : (e) ->
    @$("form .errors_").empty()
    @model.unset("errors")
    @$("form").submit()

  render : ->
    $(@el).html(@template(@model.toJSON()))
    @$('#authenticity_token').val(window.authenticity_token)
#    @$('.form-wrapper_').html($('#profile_avatars_form').html()) if @model.avatars.length < 3
    @showPreviews(@model.avatars)
    return this
