Agreatfirstdate.Views.EventItems ||= {}

class Agreatfirstdate.Views.EventItems.Show extends Backbone.View
  template: JST["event_items/show"]
  el: "#show_event_items_popup"
  
  initialize: (options) ->
    @pillar = options.pillar
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
    
    
  render: ->
    template = @template(
      pillar: @pillar
      model: @model
    )
    
    console.log @model
    
    modal = new Agreatfirstdate.Views.Application.Modal
      header: @pillar.get('name')
      body: template
      el: @el
      view: this