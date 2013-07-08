class AddDiscountCodeToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :discount_code, :string
  end
end
