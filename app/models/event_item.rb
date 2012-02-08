class EventItem < ActiveRecord::Base
  
  belongs_to :pillar
  belongs_to :user
  
    
  validates :user_id,    :presence => true
  validates :pillar_id,  :presence => true
  
end
