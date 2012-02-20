Agreatfirstdate.Views.Search ||= {}

class Agreatfirstdate.Views.Search.CountView extends Backbone.View
  initialize: () ->
    super
    @setElement($('#search #results_count'))

  render: =>
    count = @collection.length
    text = if count == 1 then 'result' else 'results'
    @$('var.count_').html("#{count} #{text}")
    return this
