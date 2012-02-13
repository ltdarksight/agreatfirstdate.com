class Agreatfirstdate.Models.EventType extends Backbone.Model
  paramRoot: 'event_type'

  defaults:
    title: null
    has_attachments: null

class Agreatfirstdate.Collections.EventTypesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventType
