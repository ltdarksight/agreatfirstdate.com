Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ShowView extends Backbone.View
  template: JST["backbone/pillars/show"]
  imagePartTemplate: JST["backbone/pillars/image_part"]

  initialize: (options) ->
    super(options)

    @model.photos.on 'reset', (collection)=>
      @render()

    @model.photos.on 'change:current', (collection)=>
      @$('.cache_').remove()
      $(@el).append(@make('div', {class: 'cache_', style: 'display: none'}, @imagePartTemplate(@model.toJSON(false))))
      @$('.category-image').flip
        color: '#FBFBFB'
        direction:'tb',
        content: @$('.cache_').html()

  render: ->
    $(@el).html(@template(@model.toJSON(false)))
    return this
