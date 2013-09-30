class AddVideoAndKindToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :video, :string
    add_column :avatars, :kind, :string, default: 'photo'
  end
end
