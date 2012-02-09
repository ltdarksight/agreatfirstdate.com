class EventItem < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :event_type
  has_many :event_descriptors, through: :event_type

  validates :pillar_id, :event_type_id, :presence => true
end
