Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Show extends Backbone.View
  template: JST["event_items/show"]
  el: "#show_event_items_popup"

  events:
    "click #delete-popup-link": "handleDelete"

  initialize: (options) ->

    @pillars = options.pillars
    @pillar = options.pillar

    @eventItems = @pillar.eventItems

    @render()
    carouselMedium = $('.carousel-medium').jcarousel();
    carouselNavigation = $('.carousel-navigation').jcarousel();

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

  handleDelete: (e)->
    e.preventDefault()
    e.stopPropagation()
    @model.destroy
      success: (model, response) =>
        @pillars.fetch()
        $(@el).modal('hide')

  render: ->
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
    }

    if @previous
      ext_data.previous_event = _.extend( @previous.toJSON(false), { photo: @previous.photo() })

    if @next
      ext_data.next_event = _.extend( @next.toJSON(false), {photo: @next.photo()})

    template = @template(_.extend(@model.toJSON(false), ext_data))

    modal = new Agreatfirstdate.Views.Application.Modal
      header: @pillar.get('name')
      body: template
      el: @el
      view: @
