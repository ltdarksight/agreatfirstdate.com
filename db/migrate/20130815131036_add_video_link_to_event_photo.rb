class AddVideoLinkToEventPhoto < ActiveRecord::Migration
  def change
    add_column :event_photos, :source, :string
    add_column :event_photos, :link, :string
    add_column :event_photos, :kind, :string, :default => 'photo'
  end
end
