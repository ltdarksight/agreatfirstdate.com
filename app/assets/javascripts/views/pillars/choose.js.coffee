Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Choose extends Backbone.View
  template: JST["pillars/choose"]
  limit: 4
  el: '#choose_pillars_popup'

  initialize: (options) ->
    @pillarCategories = options.pillarCategories
    @pillars = options.pillars
    
    @chosenPillarCategoryIds = []
    @pillars.each (pillar) ->
      @chosenPillarCategoryIds.push pillar.get('pillar_category_id')
    , this
    
    @render()
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
    'click .save': 'submit'

  categoryChange: (e) ->
    @chosenPillarCategoryIds = []
    _.each @$('.pillar_category_checkbox:checked'), (checkbox) ->
      @chosenPillarCategoryIds.push(parseInt $(checkbox).val())
    , this
      
    if @chosenPillarCategoryIds.length >= @limit
      @$('.pillar_category_checkbox:not(:checked)').attr('disabled', 'disabled')
    else
      @$('.pillar_category_checkbox:not(:checked)').removeAttr('disabled')
    
    # @model.set 'selected_pillar_ids', @chosenPillarCategoryIds

  checkCategories: ->
    @$('.pillar_category').removeAttr('checked')
    pillarIds = @model.get('selected_pillar_ids')
    _.each pillarIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this
    # @model.trigger 'change:selected_pillar_ids', @model

  resetCategories: ->
    @$('.pillar_category_:checked').removeAttr('disabled')
    false
    
  submit: ->
    userRouter.profile.set 'pillar_category_ids', @chosenPillarCategoryIds
    userRouter.profile.sync('update', userRouter.profile)
    $(@el).modal('hide')
    @pillars.fetch()

  render: ->
    template = @template(pillarCategories: @pillarCategories)
    
    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Choose your pillars'
      body: template
      el: @el
    _.each @chosenPillarCategoryIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this
    
    @categoryChange()