class CreateEventDescriptors < ActiveRecord::Migration
  def change
    create_table :event_descriptors do |t|
      t.integer :event_type_id
      t.string :name
      t.string :field_type

      t.timestamps
    end
  end
end
