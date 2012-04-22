class AddFacebookFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_id, :integer

  end
end
