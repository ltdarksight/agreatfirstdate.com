
jQuery ->
  $('#js-edit-credit-card').on 'click', (e) ->
    e.preventDefault()
    $("#manage-card-actions").hide()
    $("#card-info").show()
