class AddStrikesCountToStrikes < ActiveRecord::Migration
  def change
    add_column :strikes, :strikes_count, :integer, default: 0
    add_index :strikes, :strikes_count
    add_column :strikes, :striked_on, :date

    Strike.reset_column_information
    Strike.find_each do |strike|
      strike.increment! :strikes_count
      strike.update_column :striked_on, strike.created_at.to_date
    end
  end
end
