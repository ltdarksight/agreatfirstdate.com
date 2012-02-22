Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.FormView extends Backbone.View
  template: JST["backbone/search/form"]

  initialize: (options)->
    super
    @userSearch = options.userSearch
    @results = options.results
    @oppositeSexResults = options.oppositeSexResults
    @setElement $('#search #form_wrapper')
    _.bindAll(this, 'setEventHandlers')

  events:
    "submit form": "find"
    "change :checkbox": "setPillars"

  setEventHandlers: ->
    @userSearch.on "error", (model, error)->
      @$('.errors_').html(error)
    , this
    _.bindAll(this, "fetchOppositeSex")

    @userSearch.on "change", (model, options)->
      @$('.errors_').empty()
      @find() if _.find(_.keys(model.changedAttributes()), (changedAttribute)-> _.include(_.keys(model.searchTerms()), changedAttribute))
      @fetchOppositeSex() if _.include(_.keys(model.changedAttributes()), 'looking_for')
    , this

  setPillars: (e)->
    @userSearch.set('pillar_category_ids', _.map(@$(':checkbox:checked'), (el)->$(el).val()))

  find: (e) ->
    if e
      e.preventDefault()
      e.stopPropagation()
    @results.fetch data: @userSearch.searchTerms()

  fetchOppositeSex: ->
    @oppositeSexResults.fetch data: {gender: @userSearch.get('looking_for')}

  render: ->
    @$('form').backboneLink(@userSearch, skip: ['pillar_category_ids', 'match_type'])
    @$(':checkbox').unbind('change')
    @userSearch.set('gender', @userSearch.defaults.gender) unless @userSearch.isPresent(@userSearch.get('gender'))
    unless @userSearch.isPresent(@userSearch.get('looking_for'))
      @userSearch.set('looking_for', if 'male' == @userSearch.get('gender') then 'female' else 'male')
      @fetchOppositeSex()

    @userSearch.set('in_or_around', @userSearch.defaults.in_or_around) unless @userSearch.isPresent(@userSearch.get('in_or_around'))
    @setEventHandlers()

    return this
