class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.integer :profile_id
      t.string :image

      t.timestamps
    end
  end
end
