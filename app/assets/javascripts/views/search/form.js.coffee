Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Form extends Backbone.View

  fields:
    [ 'gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around', 'match_type', 'pillar_category_ids' ]

  events:
    "change input, select": "changeForm"

  changeForm: (event)->
    @options.results.fetch data: Backbone.Syphon.serialize(@$('form')[0], include: @fields)
