class AddAvatarToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :avatar, :string
  end
end
