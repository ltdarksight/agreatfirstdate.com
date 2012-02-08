class FixEventModelFields < ActiveRecord::Migration
  def up
    remove_column :event_items, :where
    remove_column :event_items, :when
    
    add_column :event_items, :description, :string, :default => ""
    
  end

  def down
  end
end
