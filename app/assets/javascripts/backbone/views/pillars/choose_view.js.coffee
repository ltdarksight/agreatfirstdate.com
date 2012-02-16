Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ChooseView extends Backbone.View
  template: JST["backbone/pillars/choose"]
  categoryTemplate: JST["backbone/pillars/pillar_category"]
  limit: 4

  constructor: (options) ->
    super(options)
    @pillarCategories = options.pillarCategories
    @model.bind 'change:pillar_category_ids', (model, value) ->
      if value.length >= @limit
        @$('.pillar_category_:not(:checked)').attr('disabled', 'disabled')
      else
        @$('.pillar_category_').removeAttr('disabled')
    , this

  events:
    'change .pillar_category_': 'categoryChange'

  save: (e) ->
    @model.save(null, {
      success: (pillars) =>
        pillars = pillars.toJSON().pillars
        window.router.initPillars(pillars)
        location.hash = "/index"
      error: (eventItem, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    })

  categoryChange: (e) ->
    $_checkBox = $(e.currentTarget)
    value = $_checkBox.is(':checked')
    categoryId = parseInt $_checkBox.val()
    ids = _.clone @model.get('pillar_category_ids')
    if value
      ids.push categoryId unless _.include(ids, categoryId)
      ids
    else
      ids = _.without(ids, categoryId)
    $_button = $(@el).closest('.ui-dialog').find('.ui-dialog-buttonset button:first')
    if ids.length == 0
      $_button.attr('disabled', 'disabled')
    else
      $_button.removeAttr('disabled')

    @model.set('pillar_category_ids', ids)

  checkCategories: ->
    @$('.pillar_category_').removeAttr('checked')
    pillarCategoryIds = @model.get('pillar_category_ids')
    _.each pillarCategoryIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked')
    , this
    @model.trigger('change:pillar_category_ids', @model, pillarCategoryIds)

  render: ->
    $(@el).html(@template())
    @pillarCategories.each (pillarCategory) ->
      @$('.pillar-categories_').prepend @categoryTemplate(pillarCategory.toJSON())
    , this
    @checkCategories()

    return this
    _.each @pillars.toJSON(), (pillar, id, list) ->
      $_el = $('<option/>', {value: pillar.id}).html(pillar.name)
      $_el.attr('selected', 'selected') if (pillar.id == @pillar.id)
      @$('#pillar_id').append($_el)
    , this

    return this
