class ChangePillarCategoriesImages < ActiveRecord::Migration
  def up
    PillarCategory.find_by_name("Travel").update_attributes(image: "travel.jpg")
    PillarCategory.find_by_name("Faith / Religion / Spirituality").update_attributes(image: "faith.jpg")
    PillarCategory.find_by_name("Health / Fitness").update_attributes(image: "health.jpg")
    PillarCategory.find_by_name("Sports / Sports Fan").update_attributes(image: "sports.jpg")
    PillarCategory.find_by_name("Fashion / Modeling").update_attributes(image: "fashion.jpg")
    PillarCategory.find_by_name("Eat / Drink").update_attributes(image: "food.jpg")
    PillarCategory.find_by_name("Reading / Writing / Art").update_attributes(image: "reading.jpg")
    PillarCategory.find_by_name("Music / Dancing / Nightlife").update_attributes(image: "music.jpg")
    PillarCategory.find_by_name("Movies / TV").update_attributes(image: "movies.jpg")
    PillarCategory.find_by_name("Family").update_attributes(image: "family.jpg")
    PillarCategory.find_by_name("Charity / Volunteering").update_attributes(image: "charity.jpg")
    PillarCategory.find_by_name("Education / Career").update_attributes(image: "education.jpg")
  end
  
  def down
    PillarCategory.find_by_name("Travel").update_attributes(image: "travel.png")
    PillarCategory.find_by_name("Faith / Religion / Spirituality").update_attributes(image: "faith.png")
    PillarCategory.find_by_name("Health / Fitness").update_attributes(image: "health.png")
    PillarCategory.find_by_name("Sports / Sports Fan").update_attributes(image: "sports.png")
    PillarCategory.find_by_name("Fashion / Modeling").update_attributes(image: "fashion.png")
    PillarCategory.find_by_name("Eat / Drink").update_attributes(image: "food.png")
    PillarCategory.find_by_name("Reading / Writing / Art").update_attributes(image: "reading.png")
    PillarCategory.find_by_name("Music / Dancing / Nightlife").update_attributes(image: "music.png")
    PillarCategory.find_by_name("Movies / TV").update_attributes(image: "movies.png")
    PillarCategory.find_by_name("Family").update_attributes(image: "family.png")
    PillarCategory.find_by_name("Charity / Volunteering").update_attributes(image: "charity.png")
    PillarCategory.find_by_name("Education / Career").update_attributes(image: "education.png")
  end
end
