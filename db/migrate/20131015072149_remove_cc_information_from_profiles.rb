class RemoveCcInformationFromProfiles < ActiveRecord::Migration
  def up
    remove_column :profiles, :card_exp_year
    remove_column :profiles, :card_exp_month
    remove_column :profiles, :card_cvc
    remove_column :profiles, :card_number
    remove_column :profiles, :customer_status
  end

  def down
    add_column :profiles, :card_exp_year, :string
    add_column :profiles, :card_exp_month, :string
    add_column :profiles, :card_cvc, :string, default: ''
    add_column :profiles, :card_number, :string, default: ''
    add_column :profiles, :customer_status, :boolean, default: false
  end
end
