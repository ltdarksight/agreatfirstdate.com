class EventItem < ActiveRecord::Base
  belongs_to :pillar
  belongs_to :event_type
  has_many :event_descriptors, through: :event_type
  has_many :event_items_event_photos
  has_many :event_photos, through: :event_items_event_photos

  validates :pillar_id, :event_type_id, :presence => true

  %w[date_1 date_2].each do |date_field|
    define_method("#{date_field}=") do |value|
      self[date_field] = DateTime.strptime(value, I18n.t('date.formats.default')) rescue nil
    end
  end
end
