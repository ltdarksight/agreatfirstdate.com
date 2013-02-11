root = exports ? this

root.showSlide = (id) ->
  if $("#slides").superslides("current") is id
    return false
  else
    $(".slider-link-" + $("#slides").superslides("current")).removeClass "active"
  $("#slides").superslides "animate", id
  $(".slider-link-" + id).addClass "active"