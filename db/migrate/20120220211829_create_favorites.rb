class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :profile_id
      t.integer :favorite_id

      t.timestamps
    end
  end
end
