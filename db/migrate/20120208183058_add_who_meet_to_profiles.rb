class AddWhoMeetToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :who_meet, :text

  end
end
