#= require_self
#= require_tree ../../templates
#= require_tree ./lib
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Agreatfirstdate =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  new Agreatfirstdate.Views.Feedback.ShowView()