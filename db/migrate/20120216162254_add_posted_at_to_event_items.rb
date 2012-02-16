class AddPostedAtToEventItems < ActiveRecord::Migration
  def change
    add_column :event_items, :posted_at, :datetime
  end
end
