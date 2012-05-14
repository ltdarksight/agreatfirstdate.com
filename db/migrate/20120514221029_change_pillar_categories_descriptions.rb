class ChangePillarCategoriesDescriptions < ActiveRecord::Migration
  def change
    PillarCategory.find_by_name("Sports / Sports Fan").update_attributes(description: "I am a fan. Don't bother me on game day, and you're damn right. I'll be wearing my favorite team's jersey.")
    PillarCategory.find_by_name("Reading / Writing / Art").update_attributes(description: "Give me a good book, a pen, a museum and a few hours and my batteries are fully recharged.")
    PillarCategory.find_by_name("Charity / Volunteering").update_attributes(description: "I give back. I believe in, and participate in good causes every chance I get.")
  end
end
