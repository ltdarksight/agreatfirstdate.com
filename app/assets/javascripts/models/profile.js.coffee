class Agreatfirstdate.Models.Profile extends Backbone.Model
  
  initialize: (options) ->
    @avatars = new Agreatfirstdate.Collections.Avatars(options.avatars)