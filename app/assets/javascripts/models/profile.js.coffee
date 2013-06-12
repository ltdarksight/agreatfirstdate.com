class Agreatfirstdate.Models.Profile extends Backbone.Model
  initialize: (options) ->
    @avatars = new Agreatfirstdate.Collections.Avatars(options.avatars)
    @strikes = new Agreatfirstdate.Collections.StrikesCollection(options.strikes)

  is_current: ->
    Agreatfirstdate.currentProfile.get("id") == @.get("id")

  can: (action) ->
    switch action
      when "read" then true
      when "edit" then @is_current()
      when "add_avatar" then @is_current()
      when "edit_avatar" then @is_current()
      else false

  pillar_ids: ->
    @.get("pillars").map (item) ->
      item["id"]
