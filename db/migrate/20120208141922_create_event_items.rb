class CreateEventItems < ActiveRecord::Migration
  def change
    create_table(:event_items) do |t|
      t.integer :user_id
      t.integer :pillar_id
      t.string :title
      t.string :where
      t.datetime :when
      t.text :thoughts

      t.timestamps
    end
  end
end
