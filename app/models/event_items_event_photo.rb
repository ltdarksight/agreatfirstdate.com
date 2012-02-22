class EventItemsEventPhoto < ActiveRecord::Base
  belongs_to :event_item
  belongs_to :event_photo

  validate :photo_owner

  private

  def photo_owner
    errors[:base] << 'Invalid photo id' unless event_item.pillar.profile == event_photo.profile
  end
end
