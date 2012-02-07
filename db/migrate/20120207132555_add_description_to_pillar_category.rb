class AddDescriptionToPillarCategory < ActiveRecord::Migration
  def up
    add_column :pillar_categories, :description, :string, :default => ""
    
    [
      ["Health / Fitness","I work out! I train, I play and I love an elevated heartbeat."],
      ["Faith / Religion / Spirituality","The soul is important to me. Either I go to Church or I meditate."],
      ["Sports / Sports Fan","I am a fan. Don't bother me on game, and you're dam right. I'll be wearing my favorite team's jersey."],
      ["Eat / Drink",""],
  
      ["Charity / Volunteering","I give back. I believe in, and participate in good causese every chance I get."],
      ["Travel","I get around. Whether that's trips to the city, the wild or places where English isn't ever spoken."],
      ["Education / Career","I'm educated, and I still wear my sweatshirt from the U. Or, I'm proud of what I do and I work hard at it."],
      ["Fashion / Modeling","I shop. I have style. I like to look good, and I want someone who appreciates it."],
  
      ["Family","Need I say more? Love 'em or hate 'em I can't imagine life without 'em."],
      ["Movies / TV","Give me story, give me laughter, give me plots twists!"],
      ["Music / Dancing / Nightlife","Concerts, clubs, or occasionally busting a move. My world is out there."],
      ["Reading / Writing / Art","Give me a good book, a pen, a museum and a few hours and I've my batteries fully recharged."]
  
    ].each do |category|
      
      PillarCategory.create :name => category[0], :description => category[1]
      
    end

    
  end
end
