class ChangeCardExpirationToProfile < ActiveRecord::Migration
  def up
    add_column :profiles, :card_exp_year, :string, :length => 4
    add_column :profiles, :card_exp_month, :string, :length => 2
    Profile.reset_column_information
    Profile.all.each {|profile|
      if profile.card_expiration.present?
        profile.card_exp_month = profile.card_expiration.to_s.split('/').first
        profile.card_exp_year = profile.card_expiration.to_s.split('/').last
        profile.save(:validate => false)
      end
    }
    remove_column :profiles, :card_expiration
  end

  def down
    add_column :profiles, :card_expiration, :string
    Profile.reset_column_information
    Profile.all.each {|profile|
      if profile.card_exp_month.present?
        profile.card_expiration = [profile.card_exp_month, profile.card_exp_year].join('/')
        profile.save(:validate => false)
      end
    }

    remove_column :profiles, :card_exp_year
    remove_column :profiles, :card_exp_month

  end
end
