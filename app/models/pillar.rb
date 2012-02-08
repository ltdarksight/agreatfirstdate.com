class Pillar < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pillar_category
  
  has_many :event_items
  
  validates :user_id,             :presence => true
  validates :pillar_category_id,  :presence => true
  
end
