Agreatfirstdate.Views.Pillars ||= {}

class Agreatfirstdate.Views.Pillars.ChooseView extends Backbone.View
  template: JST["backbone/pillars/choose"]
  categoryTemplate: JST["backbone/pillars/pillar_category"]
  limit: 4

  constructor: (options) ->
    super(options)
    @pillarCategories = options.pillarCategories
    @pillars = options.pillars

    @model.bind 'change:selected_pillar_ids', (model) ->
      if model.count() >= @limit
        @$('.pillar_category_:not(:checked)').attr('disabled', 'disabled')
      else
        @$('.pillar_category_:not(:checked)').removeAttr('disabled')
    , this

  events:
    'change .pillar_category_': 'categoryChange'
    'click .reset_btn': 'resetCategories'

  save: (e) ->
    @model.save(null, {
      success: (userPillars, response) =>
        @model = userPillars
        window.router.initPillars(response.pillars)
        @model.unset('pillars')
        @model.set('selected_pillar_ids', @pillars.pillarIds(), silent: true)
        location.hash = "/index"
      error: (eventItem, jqXHR) =>
        @$('.alert_message').html('<div class="popup_wrapper">' + $.parseJSON(jqXHR.responseText)[0] + '</div>').dialog
          modal: true
          buttons:
            Ok: -> $( this ).dialog( "close" )
    })

  categoryChange: (e) ->
    $_checkBox = $(e.currentTarget)
    value = $_checkBox.is(':checked')
    categoryId = parseInt $_checkBox.val()
    pillarIds = @model.get('selected_pillar_ids')

    if value
      pillarIds.push(categoryId) unless _.find(pillarIds, (pillar)=> pillar == categoryId)
    else
      @model.set 'selected_pillar_ids', _.reject(pillarIds,  (pillar)-> pillar == categoryId)

    @model.trigger 'change:selected_pillar_ids', @model
    $_button = $(@el).closest('.ui-dialog').find('.ui-dialog-buttonset button:first')
    if @model.count() == 0
      $_button.attr('disabled', 'disabled')
    else
      $_button.removeAttr('disabled')

  checkCategories: ->
    @$('.pillar_category_').removeAttr('checked')
    pillarIds = @model.get('selected_pillar_ids')
    _.each pillarIds, (id) ->
      @$("#pillar_category_#{id}").attr('checked', 'checked').attr('disabled', 'disabled')
    , this
    @model.trigger 'change:selected_pillar_ids', @model

  resetCategories: ->
    @$('.pillar_category_:checked').removeAttr('disabled')
    false

  render: ->
    $(@el).html(@template())
    @pillarCategories.each (pillarCategory) ->
      @$('.pillar-categories_').prepend @categoryTemplate(pillarCategory.toJSON())
    , this
    @checkCategories()

    return this
