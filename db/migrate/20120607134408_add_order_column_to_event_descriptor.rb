class AddOrderColumnToEventDescriptor < ActiveRecord::Migration
  def change
    add_column :event_descriptors, :order, :integer, default: 100
  end
end
