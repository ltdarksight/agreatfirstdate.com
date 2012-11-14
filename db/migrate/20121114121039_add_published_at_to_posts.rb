class AddPublishedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published_at, :datetime
    Post.reset_column_information
    Post.all.each do |post|
      post.update_attributes!(:published_at => post.created_at)
    end
  end
end
