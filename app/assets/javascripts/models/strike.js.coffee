class Agreatfirstdate.Models.Strike extends Backbone.Model
  urlRoot: "/api/strikes"

class Agreatfirstdate.Collections.StrikesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Strike
