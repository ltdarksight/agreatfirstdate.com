class RenameVideoUrlToVideoInEventPhotos < ActiveRecord::Migration
  def up
    rename_column :event_photos, :video_url, :video
  end

  def down
    rename_column :event_photos, :video, :video_url
  end
end
