class NullFalseToPublishedAtToPosts < ActiveRecord::Migration
  def change
    change_column :posts, :published_at, :datetime, :null => false
  end
end
