class AddDescriptionToPillarCategory < ActiveRecord::Migration
  def up
    add_column :pillar_categories, :description, :string, :default => ""
  end
end
