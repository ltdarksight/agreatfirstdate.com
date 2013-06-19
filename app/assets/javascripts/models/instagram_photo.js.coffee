class Agreatfirstdate.Models.InstagramPhoto extends Backbone.Model
  image: ->
    @.get("standard_resolution")

  thumbnail: ->
    @.get("thumbnail")
