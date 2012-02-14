class EventType < ActiveRecord::Base
  include EventTypesHelper

  belongs_to :pillar_category
  has_many :event_descriptors

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :title
    options[:include] = :event_descriptors
    options[:only] = [:id, :has_attachments]
    hash = super
    hash
  end

  def title
    event_type_title(self)
  end
end
