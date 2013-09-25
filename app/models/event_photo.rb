class EventPhoto < ActiveRecord::Base
  attr_accessible :image, :remote_image_url,
    :source, :kind, :link,
    :video, :remote_video_url
  belongs_to :profile
  mount_uploader :image, PhotoUploader
  mount_uploader :video, VideoUploader

  def video?
    kind.to_s == 'video'
  end
  def video_embed
    if source == 'instagram'
      %Q(<iframe src="#{video_url.to_s.gsub('http:','')}embed" width="290" height="222" frameborder="0" scrolling="no" allowtransparency="true"></iframe>)
    else
      ''
    end
  end
end
