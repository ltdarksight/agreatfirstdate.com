class Agreatfirstdate.Models.Discount extends Backbone.Model

  url: '/api/discount'

  check: ->
    @get "valid"

  discount: (amount) ->
    if @get('discount_type') == 'percent'
      amount - ((amount * @get('discount')) / 100)
    else
      amount - @get('discount')
