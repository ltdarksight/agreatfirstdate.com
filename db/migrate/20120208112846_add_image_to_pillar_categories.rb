class AddImageToPillarCategories < ActiveRecord::Migration
  def change
    add_column :pillar_categories, :image, :string
  end
end
