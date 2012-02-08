module ProfilesHelper
  
  def should_be_checked?(id)
    if Pillar.where(:user_id => current_user.id).where(:pillar_category_id => id).present?
      true
    else
      false
    end
  end
  
  def image_for_pillar(pillar)
    #TODO
    image_tag asset_path "pcategories/food.png"
  end
  
  def my_pillars_options

    my_pillars = []
    
    current_user.pillars.each do |mp|
      my_pillars << ["#{mp.pillar_category.name}", "#{mp.id}"]
    end
    
    return my_pillars
    
  end
    
end
