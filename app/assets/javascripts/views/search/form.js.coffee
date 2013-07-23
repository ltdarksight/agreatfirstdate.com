Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Form extends Backbone.View

  fields:
    [ 'gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around', 'match_type', 'pillar_category_ids' ]

  guest_fields:
    [ 'gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around' ]

  events:
    "change input, select": "changeForm"

  oppositeSex: ->
    _gender = @params()["looking_for"]
    if _gender == "male"
      "male"
    else
      "female"

  params: ->
    form = @$('form')[0]

    if @.options.me
      $pillarCategories = $(form).find('[name^=pillar_category_ids]')
      params = Backbone.Syphon.serialize(form, include: @fields)
      params['pillar_category_ids'] = []
      $.each $pillarCategories, (index, category)->
        params['pillar_category_ids'].push $(category).val() if $(category).is(':checked')

      params
    else
      Backbone.Syphon.serialize(form, include: @guest_fields)

  changeForm: (event)->
    @options.userSearch.set @params()
    @options.results.fetch data: @options.userSearch.searchTerms()
