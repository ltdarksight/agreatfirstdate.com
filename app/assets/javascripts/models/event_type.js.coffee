class Agreatfirstdate.Models.EventType extends Backbone.Model

  initialize: (options) ->
    @eventDescriptors = new Agreatfirstdate.Collections.EventDescriptors()
    if options && options.event_descriptors
      @eventDescriptors.reset options.event_descriptors
