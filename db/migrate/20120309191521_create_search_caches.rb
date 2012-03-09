class CreateSearchCaches < ActiveRecord::Migration
  def change
    create_table :search_caches do |t|
      t.integer :profile_id
      t.string :guest_hash
      t.text :pillar_ids
      t.text :result_ids

      t.timestamps
    end

    add_index :search_caches, [:guest_hash], unique: true
  end
end
