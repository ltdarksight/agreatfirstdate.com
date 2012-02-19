class AddCoordinatesToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :bounds, :text
  end
end
