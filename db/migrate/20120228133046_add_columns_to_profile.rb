class AddColumnsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :address, :text, default: ''
    add_column :profiles, :zip, :string, default: ''
    add_column :profiles, :card_number, :string, default: ''
    add_column :profiles, :card_type, :string
    add_column :profiles, :card_expiration, :string
    add_column :profiles, :card_cvc, :string
    add_column :profiles, :birthday, :date
  end
end
