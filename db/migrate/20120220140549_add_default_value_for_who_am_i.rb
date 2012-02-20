class AddDefaultValueForWhoAmI < ActiveRecord::Migration
  def change
    change_column(:profiles, :who_am_i, :text, default: '', null: false)
  end
end
