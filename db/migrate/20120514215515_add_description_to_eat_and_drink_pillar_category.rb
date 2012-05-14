class AddDescriptionToEatAndDrinkPillarCategory < ActiveRecord::Migration
  def change
    PillarCategory.find_by_name("Eat / Drink").update_attributes(description: "I live to taste.  A well cooked meal makes my day.  Add some good wine and I'm in heaven.")    
  end
end
