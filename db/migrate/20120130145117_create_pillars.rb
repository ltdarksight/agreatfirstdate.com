class CreatePillars < ActiveRecord::Migration
  def up
    create_table :pillars do |t|
      t.integer :user_id
      t.integer :pillar_category_id
      
      t.timestamps
    end
  end
end
