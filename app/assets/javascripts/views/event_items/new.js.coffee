Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.New extends Backbone.View
  template: JST["event_items/new"]
  photoTemplate: JST["event_items/photo"]
  el: "#event_items_popup"

  events:
    'click .save': 'submit'
    'change #event_type_id': 'showFields'
    'change #pillar_id': 'loadTypes'
    'click a.facebook-import': 'openFacebook'
    'click a.instagram-import': 'openInstagram'
    'change :file': 'uploadPhotos'

  initialize: (options) ->
    @pillar = options.pillar
    @pillars = options.pillars

    @model = new @pillar.eventItems.model(
      pillar_id: @pillar.id
    )

    @.on "subwindow:close", @handleCloseSubwindow, @

    @render()
    @eventPhotos = new Agreatfirstdate.Collections.EventPhotos
    @getEventTypes()

    $('form#new_event_photos').bind 'ajax:success', (e, response) =>
      @eventPhotos.add $.parseJSON(response)
      @$('.upload-status').hide()

    @eventPhotos.on('add', @appendPhoto, this)

  uploadPhotos: ->
    @$('.upload-status').show()
    $('form#new_event_photos').submit()

  openInstagram: (event) ->
    @.$el.css
      opacity: .1

    view = new Agreatfirstdate.Views.Instagram.Media
      parent: this
      target: 'event_photos_new'
      eventPhotos: @eventPhotos

  openFacebook: ->
    @.$el.css
      opacity: .1

    view = new Agreatfirstdate.Views.Facebook.BrowseAlbums
      parent: this
      model: @model
      eventPhotos: @eventPhotos

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
        value: @model.get('name')
        name: name
      ))
    , this
    $('.datepicker').datepicker
      autoclose: true
    $('.datepicker').datepicker('setDate', new Date())


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
        Agreatfirstdate.currentProfile.fetch()
      error: (eventItem, jqXHR) =>
        @showErrors($.parseJSON(jqXHR.responseText).errors)
    )

  appendPhoto: (model) ->
    $('.event_photos_previews ul').append @photoTemplate(model: model)
    eventPhotoId = $('<input/>', {type: 'text', name: 'event_photo_ids[]', value: model.id, id: "event_photo_#{model.id}_id"})
    $('form#new_event_item').append eventPhotoId.hide()
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

    @$(".photo-navigation").show()

  render: ->
    template = @template(
      choose_pillar: @pillar
      pillars: @pillars
      authenticity_token: $("meta[name=csrf-token]").attr('content')
    )

    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Add an Event'
      body: template
      el: @el
      view: this
