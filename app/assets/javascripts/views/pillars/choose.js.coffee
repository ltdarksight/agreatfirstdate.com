Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.Choose extends Backbone.View
  template: JST["pillars/choose"]
  limit: 4
  el: '#choose_pillars_popup'

  initialize: (options) ->
    @pillarCategories = options.pillarCategories
    @pillars = options.pillars
    @profile =  options.profile || Agreatfirstdate.currentProfile
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
    'click #reset-pillars': 'resetCategories'

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

  resetCategories: (event)->
    event.preventDefault()
    $('[name="selected_pillar_ids[]"]', @.$el).removeAttr('disabled').removeAttr("checked")
    @

  submit: ->
    userRouter.profile.set 'pillar_category_ids', @chosenPillarCategoryIds
    @user_pillar_categories = new Agreatfirstdate.Models.UserPillarCategories  pillar_category:
      ids: @chosenPillarCategoryIds
    @user_pillar_categories.update_categories
      success: (model, response) =>
        $(@el).modal('hide')
        @chosenPillarCategoryIds = []
        @pillars.fetch()
        userRouter.profile.fetch()
        Agreatfirstdate.currentProfile.fetch()



      error: (model, response) ->




  render: ->
    template = @template
      pillarCategories: @pillarCategories
      profile: @profile

    modal = new Agreatfirstdate.Views.Application.Modal
      header: 'Choose your pillars'
      body: template
      el: @el
    _.each @chosenPillarCategoryIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this

    @categoryChange()
