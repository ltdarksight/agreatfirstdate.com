class CreateInappropriateContents < ActiveRecord::Migration
  def change
    create_table :inappropriate_contents do |t|
      t.integer :content_id
      t.string :content_type
      t.text :reason
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
