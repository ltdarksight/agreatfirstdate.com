class AddCardExpAndLast4ToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :card_exp_month, :integer
    add_column :profiles, :card_exp_year, :integer
    add_column :profiles, :card_last4, :string
  end
end
