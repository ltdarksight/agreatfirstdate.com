class AddAddressFieldsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :address1, :string

    add_column :profiles, :address2, :string

    add_column :profiles, :city, :string

    add_column :profiles, :state, :string

  end
end
