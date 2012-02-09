class ChangeEventItemColumns < ActiveRecord::Migration
  def change
    remove_column :event_items, :user_id
    remove_column :event_items, :title
    remove_column :event_items, :thoughts
    remove_column :event_items, :description
    add_column :event_items, :event_type_id, :integer
    add_column :event_items, :string_1, :string
    add_column :event_items, :string_2, :string
    add_column :event_items, :text_1, :text
    add_column :event_items, :text_2, :text
    add_column :event_items, :date_1, :datetime
    add_column :event_items, :date_2, :datetime
  end
end
