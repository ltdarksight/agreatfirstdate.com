class AddOrderColumnToEventDescriptor < ActiveRecord::Migration
  def change
    add_column :event_descriptors, :sort, :integer, default: 100
    EventDescriptor.reset_column_information
  end
end
