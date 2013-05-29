Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.Form extends Backbone.View

  events:
    "change input, select": "changeForm"

  initialize: (options)->

  buildFormData: (input)->
    if $(input).prop('type') == 'checkbox'
      inputs = $("[name="+$(input).prop('name')+"]:checked")
      values = _.map inputs, (item, _) =>
        return $(item).prop('value')
      @options.userSearch.set($(input).attr("name"), values)
    else
      @options.userSearch.set($(input).attr("name"), $(input).val())
    @options.userSearch.searchTerms()

  changeForm: (event)->
    @options.results.fetch data: @buildFormData(event.currentTarget)
