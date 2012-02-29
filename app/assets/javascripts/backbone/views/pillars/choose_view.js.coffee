Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ChooseView extends Backbone.View
  template: JST["backbone/pillars/choose"]
  categoryTemplate: JST["backbone/pillars/pillar_category"]
  limit: 4

  constructor: (options) ->
    super(options)
    @pillarCategories = options.pillarCategories
    @pillars = options.pillars

    @model.bind 'change:pillars_attributes', (model, value) ->
      if model.count() >= @limit
        @$('.pillar_category_:not(:checked)').attr('disabled', 'disabled')
      else
        @$('.pillar_category_').removeAttr('disabled')
    , this

  events:
    'change .pillar_category_': 'categoryChange'

  save: (e) ->
    @model.save(null, {
      success: (userPillars, response) =>
        @model = userPillars
        window.router.initPillars(response.pillars)
        @model.unset('pillars')
        @model.set('pillars_attributes', @pillars.pillarsAttributes(), silent: true)
        location.hash = "/index"
      error: (eventItem, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    })

  categoryChange: (e) ->
    $_checkBox = $(e.currentTarget)
    value = $_checkBox.is(':checked')
    categoryId = parseInt $_checkBox.val()
    pillarsAttributes = @model.get('pillars_attributes')

    unless pillar = _.find(pillarsAttributes, (pillar)=> pillar.pillar_category_id == categoryId)
      pillar = {pillar_category_id: categoryId}
      pillarsAttributes.push(pillar)

    if value
      pillar['_destroy'] = false
    else
      if pillar.id then pillar['_destroy'] = true else @model.set('pillars_attributes', _.without(pillarsAttributes, pillar), silent: true)

    @model.trigger('change:pillars_attributes', @model, pillarsAttributes)

    $_button = $(@el).closest('.ui-dialog').find('.ui-dialog-buttonset button:first')
    if @model.count() == 0
      $_button.attr('disabled', 'disabled')
    else
      $_button.removeAttr('disabled')

  checkCategories: ->
    @$('.pillar_category_').removeAttr('checked')
    pillarsAttributes = @model.get('pillars_attributes')
    _.each pillarsAttributes, (pillar) ->
      @$("#pillar_category_#{pillar.pillar_category_id}").attr('checked', 'checked')
    , this
    @model.trigger('change:pillars_attributes', @model, pillarsAttributes)

  render: ->
    $(@el).html(@template())
    @pillarCategories.each (pillarCategory) ->
      @$('.pillar-categories_').prepend @categoryTemplate(pillarCategory.toJSON())
    , this
    @checkCategories()

    return this
