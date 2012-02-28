class CreateStrikes < ActiveRecord::Migration
  def change
    create_table :strikes do |t|
      t.integer :profile_id
      t.integer :striked_id

      t.timestamps
    end
  end
end
