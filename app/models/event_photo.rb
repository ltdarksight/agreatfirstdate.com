class EventPhoto < ActiveRecord::Base
  belongs_to :profile
  mount_uploader :image, PhotoUploader
end
