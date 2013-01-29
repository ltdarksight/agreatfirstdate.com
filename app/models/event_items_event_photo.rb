class EventItemsEventPhoto < ActiveRecord::Base
  belongs_to :event_item
  belongs_to :event_photo
end
