class AddCounterCacheColumnToProfiles < ActiveRecord::Migration
  def up
    add_column :profiles, :pillars_count, :integer, :default => 0

    Profile.reset_column_information
    Profile.all.each do |p|
      Profile.update_counters p.id, pillars_count: p.pillars.length
    end
  end
end
