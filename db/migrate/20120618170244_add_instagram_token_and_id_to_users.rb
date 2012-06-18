class AddInstagramTokenAndIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram_token, :string
    add_column :users, :instagram_id, :integer
  end
end
