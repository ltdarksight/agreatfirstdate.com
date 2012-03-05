class AddStripeStatusColumnsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :customer_status, :boolean, default: false
    add_column :profiles, :customer_subscription_status, :boolean, default: false
    add_column :profiles, :invoice_status, :boolean, default: false
  end
end
