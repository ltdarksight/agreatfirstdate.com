class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :profile_id
      t.integer :subject_id
      t.string :subject_type

      t.timestamps
    end
  end
end
