class EventType < ActiveRecord::Base
  include EventTypesHelper

  belongs_to :pillar_category
  has_many :event_descriptors

  def serializable_hash(options = nil)
    hash = super
    hash[:title] = event_type_title(self)
    hash
  end
end
