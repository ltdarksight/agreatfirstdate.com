class AddTodaySignInCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :today_sign_in_count, :integer, :default => 0

  end
end
