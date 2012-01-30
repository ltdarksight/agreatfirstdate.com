class CreatePillarCategories < ActiveRecord::Migration
  def up
    create_table :pillar_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
