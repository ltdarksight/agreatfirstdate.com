Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.FormView extends Backbone.View
  template: JST["backbone/search/form"]

  initialize: (options)->
    super
    @user = options.user
    @results = options.results
    @setElement $('#search #form_wrapper')
    @user.on "error", (model, error)->
      $('.errors_').html(error)
    @user.on "change", (model, options)->
      $('.errors_').empty()

  events:
    "submit form": "find"
    "change :radio": "setMatch"
    "change :checkbox": "setPillars"

  setMatch: (e)->
    @user.set('match_type', $(e.currentTarget).val(), {silent: true})

  setPillars: (e)->
    @user.set('pillar_ids', _.map(@$(':checkbox:checked'), (el)->$(el).val()), {silent: true})

  find: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @results.fetch data: @user.searchTerms()

  render: ->
    $(@el).append('hi')
#    $(@el).html(@template(@user.toJSON() ))
    @$('form').backboneLink(@user)
    @$(':radio').unbind('change')
    @$(':checkbox').unbind('change')

    @$(':checkbox:first, :radio:checked').trigger('change')
    return this
