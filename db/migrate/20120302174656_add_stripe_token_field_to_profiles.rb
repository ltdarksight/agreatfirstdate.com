class AddStripeTokenFieldToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :stripe_customer_token, :string, default: ''
    change_column_default :profiles, :card_expiration, ''
    change_column_default :profiles, :card_type, ''
    change_column_default :profiles, :card_cvc, ''
  end
end
