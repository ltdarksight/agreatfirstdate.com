class AddPillarCategoryArrayToProfile < ActiveRecord::Migration

  def up
    add_column :profiles, :pillar_category_array, :text_array
    Profile.reset_column_information
    Profile.find_each do |pr|
      pr.pillar_category_array = pr.pillar_category_ids
      pr.save(:validate => false)
    end
  end

  def down
    remove_column :profiles, :pillar_category_array
  end

end
