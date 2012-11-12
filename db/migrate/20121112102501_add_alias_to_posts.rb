class AddAliasToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :alias, :string
  end
end
