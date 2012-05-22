class AddLookingForAgeFromAndToFieldsToProfiles < ActiveRecord::Migration
  class Profile < ActiveRecord::Base
    AGES = {"18-24" => [18, 24], "25-36" => [25, 36], "37-50" => [37, 50], "50 and over" => [50, 75]}

    def looking_for_age_from
      looking_for_age.blank? ? 18 : (AGES[looking_for_age] || looking_for_age.split('-')).first.to_i
    end

    def looking_for_age_to
      looking_for_age.blank? ? 50 : (AGES[looking_for_age] || looking_for_age.split('-')).last.to_i
    end
  end

  def up
    change_table :profiles do |t|
      t.integer :looking_for_age_from, :looking_for_age_to
    end

    Profile.reset_column_information
    Profile.all.each do |profile|
      profile.update_attributes :looking_for_age_from => profile.looking_for_age_from, :looking_for_age_to => profile.looking_for_age_to
    end

    remove_column :profiles, :looking_for_age
  end

  def down
    add_column :profiles, :looking_for_age, :string, :default => ''

    Profile.reset_column_information
    Profile.all.each do |profile|
      profile.update_attributes :looking_for_age => [profile[:looking_for_age_from], profile[:looking_for_age_to]].join('-')
    end

    change_table :profiles do |t|
      t.remove :looking_for_age_from, :looking_for_age_to
    end
  end
end
