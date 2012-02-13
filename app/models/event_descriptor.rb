class EventDescriptor < ActiveRecord::Base
  include EventDescriptorsHelper
  belongs_to :event_type

  def title
    event_descriptor_title(self)
  end
end
