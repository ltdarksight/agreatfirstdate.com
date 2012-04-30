class AddPillarsChangedAtToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :pillars_changed_at, :datetime

  end
end
