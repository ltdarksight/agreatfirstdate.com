class Agreatfirstdate.Models.EventDescriptor extends Backbone.Model
  paramRoot: 'event_descriptor'

  defaults:
    event_type_id: null
    name: null
    field_type: null

class Agreatfirstdate.Collections.EventDescriptorsCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventDescriptor
  url: '/event_descriptors'
