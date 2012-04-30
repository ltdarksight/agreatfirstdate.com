class AddActiveToPillars < ActiveRecord::Migration
  def change
    add_column :pillars, :active, :boolean, :default => true

  end
end
