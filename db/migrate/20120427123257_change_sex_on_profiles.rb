class ChangeSexOnProfiles < ActiveRecord::Migration
  def up
    change_column_default :profiles, :gender, 'male'
    change_column_default :profiles, :looking_for, 'female'
  end

  def down
    change_column_default :profiles, :gender, nil
    change_column_default :profiles, :looking_for, nil
  end
end
