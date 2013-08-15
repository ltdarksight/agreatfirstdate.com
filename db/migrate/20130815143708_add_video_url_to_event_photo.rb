class AddVideoUrlToEventPhoto < ActiveRecord::Migration
  def change
    add_column :event_photos, :video_url, :string
  end
end
