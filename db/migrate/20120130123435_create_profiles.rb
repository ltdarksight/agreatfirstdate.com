class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.text :who_am_i
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :looking_for
      t.string :in_or_around
      t.string :age

      t.timestamps
    end
  end
end
