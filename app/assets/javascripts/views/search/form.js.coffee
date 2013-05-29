Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Form extends Backbone.View

  events:
    "change input, select": "changeForm"

  initialize: (options)->

  buildFormData: (input)->
    @options.userSearch.set($(input).attr("name"), $(input).val())
    @options.userSearch.searchTerms()

  changeForm: (event)->
    @options.results.fetch data: @buildFormData(event.currentTarget)
