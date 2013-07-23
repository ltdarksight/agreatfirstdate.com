class PillarCategory < ActiveRecord::Base
  has_many :pillars
  has_many :event_types

  validates :name, :presence => true
  validates :name, :uniqueness => true
  attr_accessible :name, :description, :image

  def image_url
    "/assets/pcategories/#{image}"
    # "/assets/pcategories/movies.png"
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :image_url
    super
  end
end
