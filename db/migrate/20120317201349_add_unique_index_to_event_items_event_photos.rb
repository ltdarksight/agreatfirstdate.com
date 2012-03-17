class AddUniqueIndexToEventItemsEventPhotos < ActiveRecord::Migration
  def change
    add_index(:event_items_event_photos, [:event_item_id, :event_photo_id], :unique => true, :name => 'by_item_photo')
  end
end
