class RenameOrderColumnToSortInEventDescriptors < ActiveRecord::Migration
  def up
    rename_column :event_descriptors, :order, :sort
  end

  def down
    rename_column :event_descriptors, :sort, :order
  end
end
