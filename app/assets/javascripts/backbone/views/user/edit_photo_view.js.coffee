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

  events:
    "change input[type=file]": "update"

  showPreviews: (collection)->
    @$('.avatars, .large_').empty()
    collection.each (avatar, id) ->
      view = new Agreatfirstdate.Views.User.EditPhotoPreviewView({model: avatar, user: @model})
      @$('.avatars').append view.render().el
      view.showLarge() if 0 == id
    , this

  update : (e) ->
    @$("form .errors_").append $("<img src='/assets/ajax-loader.gif'></img>")
    @model.unset("errors")
    @$("form").submit()

  render : ->
    $(@el).html(@template(@model.toJSON(false)))
    @$('#authenticity_token').val(window.authenticity_token)
    @$('form').toggle @model.avatars.length < 3
    @showPreviews(@model.avatars)
    return this
