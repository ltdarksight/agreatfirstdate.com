class CreateEventItemsEventPhotos < ActiveRecord::Migration
  def change
    create_table :event_items_event_photos do |t|
      t.integer :event_item_id
      t.integer :event_photo_id

      t.timestamps
    end
  end
end
