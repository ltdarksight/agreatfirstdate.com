class AddContentTypeToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :content_type, :string, default: '', null: false
    add_column :avatars, :file_size, :string, default: '0', null: false
  end
end
