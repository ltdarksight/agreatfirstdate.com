class AddBillingFullNameToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :billing_full_name, :string
  end
end
