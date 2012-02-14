class Agreatfirstdate.Models.EventType extends Backbone.Model
  paramRoot: 'event_type'

  defaults:
    title: null
    has_attachments: null

  initialize: (options) ->
    @eventDescriptors = new Agreatfirstdate.Collections.EventDescriptorsCollection()
    if options && options.event_descriptors
      @eventDescriptors.reset options.event_descriptors

class Agreatfirstdate.Collections.EventTypesCollection extends Backbone.Collection
  model: Agreatfirstdate.Models.EventType
