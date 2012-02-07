module ProfilesHelper
  
  def should_be_checked?(id)
    if Pillar.where(:user_id => current_user.id).where(:pillar_category_id => id).present?
      true
    else
      false
    end
  end
    
end
