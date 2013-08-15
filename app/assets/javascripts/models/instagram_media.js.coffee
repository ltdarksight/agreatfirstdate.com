class Agreatfirstdate.Models.InstagramMedia extends Backbone.Model
  images: ->
    @.get "images"

  image: ->
    @images()["standard_resolution"]

  thumbnail: ->
    @images()["thumbnail"]

  type: ->
    @.get 'type'

  link: ->
    @.get 'link'

  videos: ->
    @get "videos"

  video_link: ->
    @videos()['standard_resolution']['url']
