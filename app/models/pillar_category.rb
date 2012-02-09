class PillarCategory < ActiveRecord::Base
  has_many :pillars
  has_many :event_types

  validates :name, :presence => true
  validates :name, :uniqueness => true
end
