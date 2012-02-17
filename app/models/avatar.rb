class Avatar < ActiveRecord::Base
  mount_uploader :image, AvatarUploader
  belongs_to :profile
end
