class Agreatfirstdate.Models.Profile extends Backbone.Model
  initialize: (options) ->
    @avatars = new Agreatfirstdate.Collections.Avatars(options.avatars)
    @strikes = new Agreatfirstdate.Collections.StrikesCollection(options.strikes)
