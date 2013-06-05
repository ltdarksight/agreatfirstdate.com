Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.ResultsCount extends Backbone.View
  template: JST['search/results_count']
  defaults:
    count: 0
  render: (count) ->
    @.$el.html @template({ count: count})
