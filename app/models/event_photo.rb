class EventPhoto < ActiveRecord::Base
  attr_accessible :image, :remote_image_url
  belongs_to :profile
  mount_uploader :image, PhotoUploader
end
