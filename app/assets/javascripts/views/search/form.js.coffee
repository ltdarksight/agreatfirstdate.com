Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Form extends Backbone.View

  fields:
    [ 'gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around', 'match_type', 'pillar_category_ids' ]

  guest_fields:
    [ 'gender', 'looking_for', 'looking_for_age_from', 'looking_for_age_to', 'in_or_around' ]

  events:
    "change input, select": "changeForm"

  params: ->
    if @.options.me
      Backbone.Syphon.serialize(@$('form')[0], include: @fields)
    else
      Backbone.Syphon.serialize(@$('form')[0], include: @guest_fields)

  changeForm: (event)->
    @options.results.fetch data: @params()
