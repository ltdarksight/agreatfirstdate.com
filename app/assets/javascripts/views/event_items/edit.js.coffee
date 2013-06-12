Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Edit extends Backbone.View
  template: JST["event_items/edit"]
  photoTemplate: JST["event_items/photo"]
  el: "#event_items_popup"

  events:
    'click .save': 'submit'
    "change #event_type_id": "showFields"
    "change .event_photo_image": "uploadPhotos"
    'ajax:complete': 'addPhotos'
    "change #pillar_id": "loadTypes"
    "click a.facebook-import": "openFacebook"

  initialize: (options) ->
    @pillar = options.pillar
    @pillars = options.pillars
    @.on "subwindow:close", @handleCloseSubwindow, @

    @render()
    @eventPhotos = @model.eventPhotos
    @getEventTypes()
    @showPhotos()

    #
    # @model.eventPhotos.bind 'add', (model, collection) ->
    #   $_eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id, id: "event_photo_#{model.id}_id"})
    #   @$('form').append $_eventPhotoId.hide()
    #   @$("form").backboneLink(@model)
    # , this
    #
    # @model.eventPhotos.bind 'remove', (model, collection) ->
    #   @$("#event_photo_#{model.id}_id").remove()
    #   @$("form").backboneLink(@model)
    # , this
    #
    #@model.on "change:errors", (model, response)->
    #  if response
    #    _.each response.errors, (errors, field)->
    #      @$(":input[name=#{field}]").after($("<span></span>", {"class": "error"}).html(_(errors).first()))
    #    , this
    #  else
    #    @$('span.error').remove()
    #, this


  openFacebook: ->
    @.$el.css
      opacity: .1

    view = new Agreatfirstdate.Views.Facebook.BrowseAlbumsView
      parent: @
      model: @model

  handleCloseSubwindow: ->
    @.$el.css
      opacity: 1

  showErrors: (errors) ->
    $("span.error", $.el).remove()
    _.each errors, (errors, field)->
      @$(":input[name=#{field}]").after($("<span></span>", {"class": "error"}).html(_(errors).first()))

  showFields: (e) ->
    eventTypeId = $(e.target).val()
    @model.eventType = @model.eventTypes.get(eventTypeId)

    fieldIds = {date: 1, string: 1, text: 1}
    $('#event_type_fields').empty()

    @model.eventType.eventDescriptors.each (descriptor) ->
      fieldType = descriptor.get('field_type')
      name = "#{fieldType}_#{fieldIds[fieldType]++}"
      @$('#event_type_fields').append(JST["event_items/fields/#{fieldType}"](
        label: descriptor.get('title')
        value: @model.get(name)
        name: name
      ))
    , this
    $('.datepicker').datepicker()

  loadTypes: (e) ->
    @pillar = @pillars.get $(e.target).val()
    @model.set('pillar_id', @pillar.id)
    @getEventTypes()

  getEventTypes: ->
    @model.eventTypes = new Agreatfirstdate.Collections.EventTypes
    @model.eventTypes.url = '/api/pillars/'+@pillar.id+'/event_types'
    @model.eventTypes.fetch {success: @fillTypes}

  fillTypes: (eventTypes) ->
    $_eventTypes = @$('#event_type_id')
    $_eventTypes.empty()
    _.each eventTypes.toJSON(), (eventType, id, list) ->
      $_eventTypes.append($('<option/>', {value: eventType.id}).html(eventType.title))
    $_eventTypes.trigger 'change'

  submit: (e) ->
    @model.set('event_photo_ids', _.map(@$('input[name="event_photo_ids[]"]'), (el) -> $(el).val()))

    _.each @model.attributes, (value, key) ->
      @model.set(key, $('#'+key).val()) if $('#'+key).val()
    , this


    params = $.extend @model.toJSON(),
      event_type: @model.eventTypes.get(@model.eventType.id).toJSON()

    @pillar.eventItems.create(params,
      success: (eventItem, response) =>
        @pillars.fetch()
        $(@el).modal('hide')
      error: (eventItem, jqXHR) =>
        @showErrors($.parseJSON(jqXHR.responseText).errors)
    )
    #
    # @model.set('event_photo_ids', _.map(@$('input[name="event_photo_ids[]"]'), (el) -> $(el).val()))
    # @model.unset("errors")
    # params = $.extend @model.toJSON(false),
    #     event_photos: @model.eventPhotos.toJSON()
    #     event_type: @model.eventTypes.get(@model.get('event_type_id')).toJSON()
    #
    # @pillar.eventItems.create(params,
    #   success: (eventItem, response) =>
    #     @model = eventItem
    #     @model.set(response.event_item)
    #
    #     @model.calcDistance(response.event_item.date_1)
    #     @pillar.eventItems.sort({silent: true})
    #     @pillar.photos.reset response.pillar_photos
    #     window.location.hash = "/index"
    #
    #   error: (eventItem, jqXHR) =>
    #     @model.set({errors: $.parseJSON(jqXHR.responseText)})
    #     @pillar.eventItems.remove eventItem
    # )

  uploadPhotos: ->
    $('.upload-status').append $("<img src='/assets/file-loader.gif'></img>")
    $('form#new_event_photos').submit()

  addPhotos: (e, data) ->
    eventPhotos = $.parseJSON(data.responseText)

    $('.upload-status').hide()
    _.each eventPhotos, (eventPhoto) ->
      @eventPhotos.add(eventPhoto)
      $('.event_photos_previews ul').append @photoTemplate(eventPhoto)
      eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: eventPhoto.id, id: "event_photo_#{eventPhoto.id}_id"})
      $('form#new_event_item').append eventPhotoId.hide()
    , this
    carouselNavigation = $('.event_photos_previews').jcarousel()
    carouselNavigation.jcarousel("items").each ->
      item = $(this)
      item.on("active.jcarouselcontrol", ->
        carouselNavigation.jcarousel('scrollIntoView', this);
        item.addClass "active"
      ).on("inactive.jcarouselcontrol", ->
        item.removeClass "active"
      ).jcarouselControl target: item.index()
    $(".prev-navigation").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "-=1"
    $(".next-navigation").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "+=1"

  showPhotos: ->
    _.each @eventPhotos.models, (eventPhoto) ->
      $('.event_photos_previews ul').append @photoTemplate(eventPhoto.toJSON())
      eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: eventPhoto.id, id: "event_photo_#{eventPhoto.id}_id"})
      $('form#new_event_item').append eventPhotoId.hide()
    , @

    carouselNavigation = $('.event_photos_previews').jcarousel()
    carouselNavigation.jcarousel("items").each ->
      item = $(@)
      item.on("active.jcarouselcontrol", ->
        carouselNavigation.jcarousel('scrollIntoView', this);
        item.addClass "active"
      ).on("inactive.jcarouselcontrol", ->
        item.removeClass "active"
      ).jcarouselControl target: item.index()
    $(".prev-navigation").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "-=1"
    $(".next-navigation").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "+=1"

  render: ->
    template = @template(
      photos: @model.eventPhotos
      choose_pillar: @pillar
      pillars: @pillars
      authenticity_token: $("meta[name=csrf-token]").attr('content')
    )

    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Edit Event: ' + @pillar.get("name")
      body: template
      el: @el
      view: @