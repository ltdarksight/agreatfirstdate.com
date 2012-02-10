class EventDescriptorsController < ApplicationController
  layout false
  def index
    @event_type = EventType.find(params[:event_type_id])
    @descriptors = @event_type.event_descriptors
  end
end