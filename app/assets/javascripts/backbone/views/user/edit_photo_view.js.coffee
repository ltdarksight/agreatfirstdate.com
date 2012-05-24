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
        @$("form .errors_").html error
        @$("form .loader").hide()
    , this)

  events:
    "change input[type=file]": "update"
    "click a.facebook_import": "open_facebook"

  open_facebook: ->
    $('#profile_popup').dialog('close')

    view = new Agreatfirstdate.Views.Facebook.BrowseAlbumsView({model: @model})
    view.$el.dialog
      height: 586
      width: 868
      draggable: false
      modal: true
      buttons:
        "Close": -> $(this).dialog('close')
    false

  showPreviews: (collection)->
    @$('.avatars, .large_').empty()
    if collection.length > 0
      @$('.avatars').before "<h3>Images</h3>"
    collection.each (avatar, id) ->
      view = new Agreatfirstdate.Views.User.EditPhotoPreviewView({model: avatar, user: @model})
      @$('.avatars').append view.render().el
      view.showLarge() if 0 == id
    , this

  update : (e) ->
    @$("form .loader").show()
    @model.unset("errors")
    @$("form").submit()

  render : ->
    $(@el).html(@template(@model.toJSON(false)))
    @$('#authenticity_token').val(window.authenticity_token)
    @$('form').toggle @model.avatars.length < 3
    @showPreviews(@model.avatars)
    return this
