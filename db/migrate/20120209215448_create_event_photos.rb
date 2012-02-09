class CreateEventPhotos < ActiveRecord::Migration
  def change
    create_table :event_photos do |t|
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
