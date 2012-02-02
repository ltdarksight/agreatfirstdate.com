class AddPointsToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :points, :integer, :default => 100
  end
end
