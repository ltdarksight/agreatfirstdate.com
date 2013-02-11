root = exports ? this

root.showSlide = (id) ->
  if $("#slides").superslides("current") is id
    return false
  else
    $(".slider-link-" + $("#slides").superslides("current")).removeClass "active"
  $("#slides").superslides "animate", id
  
  
  # init.slides
  # animated.slides
$(document).ready ->
  $(document).on "init.slides", ->
    $(".slider-link-" + $("#slides").superslides("current")).addClass "active"
  $(document).on "animated.slides", ->
    $(".slider-link-" + $("#slides").superslides("prev")).removeClass "active"
    $(".slider-link-" + $("#slides").superslides("next")).removeClass "active"
    $(".slider-link-" + $("#slides").superslides("current")).addClass "active"
  