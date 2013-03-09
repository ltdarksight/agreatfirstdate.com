class EventPhoto < ActiveRecord::Base
  attr_accessible :image
  belongs_to :profile
  mount_uploader :image, PhotoUploader
end
