class AddLookingForAgeToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :looking_for_age, :string, :default => "" 
  end
end
