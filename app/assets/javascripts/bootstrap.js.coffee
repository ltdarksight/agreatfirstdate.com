jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  
  $('.dropdown-toggle').dropdown();
  $('.dropdown input, .dropdown label').click (e) ->
    e.stopPropagation()
  