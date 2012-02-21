class ChangeUserIdToProfileId < ActiveRecord::Migration
  def change
    rename_column :event_photos, :user_id, :profile_id
    rename_column :pillars, :user_id, :profile_id
  end
end
