class EventDescriptor < ActiveRecord::Base
  include EventDescriptorsHelper
  belongs_to :event_type
  
  default_scope order('sort')

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :title
    options[:only] = [:id, :name, :field_type]
    hash = super
    hash
  end

  def title
    event_descriptor_title(self)
  end
end
