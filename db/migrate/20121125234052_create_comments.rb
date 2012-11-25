class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :commentable, :polymorphic => true
      
      t.string  :full_name
      t.text :body
      
      t.timestamps
    end
  end
end
