class AddRoleColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: 'user'
    add_column :profiles, :status, :string, default: 'active'
    add_column :event_items, :status, :string, default: 'active'
  end
end
