class Avatar < ActiveRecord::Base
  attr_accessible :image, :bounds, :remote_image_url, :kind, :remote_video_url

  LIMIT = 3

  acts_as_estimable profile: :profile

  mount_uploader :image, AvatarUploader
  mount_uploader :video, VideoUploader

  serialize :bounds

  belongs_to :profile

  before_save :update_image_attributes
  before_create :reset_bounds
  before_update :crop_thumb

  validate :check_limit, on: :create

  def crop_thumb
    x, y, x2, y2 = bounds
    w = x2 - x
    h = y2 - y
    image.thumb.x, image.thumb.y, image.thumb.w, image.thumb.h = x, y, w, h
    image.preview.x, image.preview.y, image.preview.w, image.preview.h = x, y, w, h
    image.recreate_versions!
  end

  def reset_bounds
    self.bounds = [0, 0] + AvatarUploader::GEOMETRY[:source].values
  end

  # def serializable_hash(options = nil)
  #   options = options ? options.clone : {}
  #   options[:include] = :image
  #   hash = super
  #   thumb_size = AvatarUploader::GEOMETRY[:thumb].values
  #   hash[:aspect_ratio] = thumb_size[0].to_f/thumb_size[1].to_f
  #   hash
  # end

  def check_limit
    errors[:base] << "Only #{LIMIT} profile pictures are allowed. Please delete one before adding another." if profile.avatars.reload.count >= LIMIT
  end

private
  def update_image_attributes
    if image.present? && image_changed?
      self.content_type = image.file.content_type
      self.file_size = image.file.size
    end
  end
end
