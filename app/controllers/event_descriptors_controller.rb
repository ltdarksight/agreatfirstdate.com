class EventDescriptorsController < ApplicationController
  layout false
  def index
    @descriptors = EventType.find(params[:event_type_id]).event_descriptors
  end
end