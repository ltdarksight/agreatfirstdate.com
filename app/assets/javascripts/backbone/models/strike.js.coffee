class Agreatfirstdate.Models.Strike extends Backbone.Model
  defaults:
    striked_id: null

class Agreatfirstdate.Collections.StrikesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.Strike
