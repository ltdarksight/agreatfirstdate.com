Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Choose extends Backbone.View
  template: JST["pillars/choose"]
  limit: 4

  initialize: (options) ->
    @pillarCategories = options.pillarCategories
    @chosenPillarCategoryIds = options.chosenPillarCategoryIds
    # @pillars = options.pillars
    # 
    # @model.bind 'change:selected_pillar_ids', (model) ->
    #   if model.count() >= @limit
    #     @$('.pillar_category_:not(:checked)').attr('disabled', 'disabled')
    #   else
    #     @$('.pillar_category_:not(:checked)').removeAttr('disabled')
    # , this

  # events:
  #   'change .pillar_category_': 'categoryChange'
  #   'click .reset_btn': 'resetCategories'
  events:
    'change .pillar_category_checkbox': 'categoryChange'

  categoryChange: (e) ->
    @chosenPillarCategoryIds = []
    _.each @$('.pillar_category_checkbox:checked'), (checkbox) ->
      @chosenPillarCategoryIds.push(parseInt $(checkbox).val())
    , this
      
    if @chosenPillarCategoryIds.length >= @limit
      @$('.pillar_category_checkbox:not(:checked)').attr('disabled', 'disabled')
    else
      @$('.pillar_category_checkbox:not(:checked)').removeAttr('disabled')

  checkCategories: ->
    @$('.pillar_category').removeAttr('checked')
    pillarIds = @model.get('selected_pillar_ids')
    _.each pillarIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this
    @model.trigger 'change:selected_pillar_ids', @model

  resetCategories: ->
    @$('.pillar_category_:checked').removeAttr('disabled')
    false

  render: ->
    $(@el).html(@template(pillarCategories: @pillarCategories))
    _.each @chosenPillarCategoryIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this
    
    @categoryChange()

    this