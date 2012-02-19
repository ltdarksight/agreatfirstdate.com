class AddDefaultValuesForModels < ActiveRecord::Migration
  def change
    change_column(:profiles, :who_meet, :text, default: '', null: false)
    change_column(:profiles, :first_name, :string, default: '', null: false)
    change_column(:profiles, :last_name, :string, default: '', null: false)
  end
end
