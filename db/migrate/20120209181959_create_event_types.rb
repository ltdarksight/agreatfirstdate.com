class CreateEventTypes < ActiveRecord::Migration
  def change
    create_table :event_types do |t|
      t.integer :pillar_category_id
      t.string :name
      t.boolean :has_attachments, default: false

      t.timestamps
    end
  end
end
