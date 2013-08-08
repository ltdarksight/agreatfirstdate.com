class AddProfileUpdatedAtToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :profile_updated_at, :datetime
    Profile.reset_column_information
    Profile.update_all :profile_updated_at => Time.current
  end
  def down
    remove_column :profiles, :profile_updated_at
  end
end
