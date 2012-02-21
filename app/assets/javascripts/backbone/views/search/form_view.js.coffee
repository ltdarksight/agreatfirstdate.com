Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.FormView extends Backbone.View
  template: JST["backbone/search/form"]

  initialize: (options)->
    super
    @userSearch = options.userSearch
    @results = options.results
    @setElement $('#search #form_wrapper')
    @userSearch.on "error", (model, error)->
      @$('.errors_').html(error)
    , this
    @userSearch.on "change", (model, options)->
      @$('.errors_').empty()
      @find() if _.find(_.keys(model.changedAttributes()), (changedAttribute)-> _.include(_.keys(model.searchTerms()), changedAttribute))
    , this

  events:
    "submit form": "find"
    "change :checkbox": "setPillars"

  setPillars: (e)->
    @userSearch.set('pillar_category_ids', _.map(@$(':checkbox:checked'), (el)->$(el).val()))

  find: (e) ->
    if e
      e.preventDefault()
      e.stopPropagation()
    @results.fetch data: @userSearch.searchTerms()

  render: ->
    @$('form').backboneLink(@userSearch, skip: ['pillar_category_ids', 'match_type'])
    @$(':checkbox').unbind('change')
    return this
