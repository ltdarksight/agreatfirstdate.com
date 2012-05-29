Agreatfirstdate.Views.EventPhotos ||= {}

class Agreatfirstdate.Views.EventPhotos.NewView extends Backbone.View
  template: JST["backbone/event_photos/form"]
  preview: JST["backbone/event_photos/preview"]

  events:
    "change .event_photo_image_": "save"
    "click a.facebook-import": "openFacebook"

  constructor: (options) ->
    super(options)
    @pillar = options.pillar
    @facebook_token = options.facebook_token
    @model = new @collection.model()
    @collection.bind 'add', (model, collection) ->
      @render()
    , this

    @model.bind("change:errors", () =>
      this.render()
    )
    options.eventItem.bind("change:event_type_id", (model, value) =>
      @$("form").toggle model.eventTypes.get(value).get('has_attachments')
    )

  openFacebook: ->
    view = new Agreatfirstdate.Views.Facebook.BrowseAlbumsView({model: @model, target: "event_photos_new"})
    $("#profile_popup").html(view.$el)
    $("#profile_popup").dialog(
        title: "aGreatFirstDate - Profile",
        width: 705,
        resizable: false,
        draggable: false,
        modal: true,
        buttons: {
          "Close": -> $(this).dialog('destroy')
        },
        close: ->
          location.hash = "/index"
      )
    $("#profile_popup").dialog('show')
    false

  addAll: () =>
    @collection.each(@addOne)

  addOne: (eventPhoto) =>
    view = new Agreatfirstdate.Views.EventPhotos.EventPhotoView({collection: @collection, model: eventPhoto, id: 'event_photo_'+eventPhoto.id})
    @$('.event_photos_previews_').append view.render(true).el

  save: (e) ->
    @$('.upload-status_').append $("<img src='/assets/file-loader.gif'></img>")
    @model.unset("errors")
    @$("form").submit()

  render: ->
    $(@el).html(@template(facebook_token: @facebook_token))
    @$('#pillar_id').val(@pillar.id)
    @$('#authenticity_token').val(window.authenticity_token)
    @addAll()
    $('.event_photos_previews_').jcarousel
      scroll: 1
    
    return this
