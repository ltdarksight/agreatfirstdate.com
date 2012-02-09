class EventPhoto < ActiveRecord::Base
  mount_uploader :image, PhotoUploader
end
