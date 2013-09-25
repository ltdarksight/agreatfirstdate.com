Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Show extends Backbone.View
  template: JST["event_items/show"]
  template_head: JST["event_items/show_header"]
  el: "#show_event_items_popup"

  events:
    "click #delete-popup-link": "handleDelete"
    "click .play-event-video" : 'handlePlayVideo'

  initialize: (options) ->
    @pillars = options.pillars
    @pillar = options.pillar

    @eventItems = @pillar.eventItems

    @render()
    carouselMedium = $('.carousel-medium').jcarousel()
    carouselNavigation = $('.carousel-navigation').jcarousel()

    connector = (itemNavigation, carouselMedium) ->
      carouselMedium.jcarousel("items").eq itemNavigation.index()

    carouselNavigation.jcarousel("items").each ->
      item = $(this)
      target = connector(item, carouselMedium)
      item.on("active.jcarouselcontrol", ->
        carouselNavigation.jcarousel "scrollIntoView", this
        item.addClass "active"
      ).on("inactive.jcarouselcontrol", ->
        item.removeClass "active"
      ).jcarouselControl
        target: target
        carousel: carouselMedium

    $(".prev-medium").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "-=1"
    $(".next-medium").on("inactive.jcarouselcontrol", ->
      $(this).addClass "inactive"
    ).on("active.jcarouselcontrol", ->
      $(this).removeClass "inactive"
    ).jcarouselControl target: "+=1"

  handlePlayVideo: (event) ->
    event.preventDefault()
    event.stopPropagation()
    modal_video = new Agreatfirstdate.Views.Application.Video
      header: "Play Video"
      source_url: $(event.target).data()['link']
      el: $("#play-video")
      allowSave: false
      view: @


  handleDelete: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.destroy
      success: (model, response) =>
        @pillars.fetch()
        $(@el).modal('hide')
        Agreatfirstdate.currentProfile.fetch()


  render: ->
    $(@el).off 'click', '#delete-popup-link'
    currentIndex = @eventItems.indexOf @model
    @previous = @eventItems.previousTo currentIndex
    @next = @eventItems.nextTo currentIndex

    ext_data = {
      pillar: @pillar,
      model: @model,
      next: @next,
      previous: @previous,
      previous_event: null,
      next_event: null
      has_photo: if @model.eventPhotos.length > 0 then true else false
    }

    if @previous
      ext_data.previous_event = _.extend( @previous.toJSON(false), { photo: @previous.photo() })

    if @next
      ext_data.next_event = _.extend( @next.toJSON(false), {photo: @next.photo()})

    template = @template(_.extend(@model.toJSON(false), ext_data))
    template_head = @template_head
      model: @model
      pillar: @pillar

    modal = new Agreatfirstdate.Views.Application.Modal
      header: template_head
      body: template
      el: @el
      view: @
