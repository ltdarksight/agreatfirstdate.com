class PillarCategory < ActiveRecord::Base
  
  has_many :pillars
  
  validates :name, :presence => true
  validates :name, :uniqueness => true
  
end
