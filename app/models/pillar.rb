class Pillar < ActiveRecord::Base
  belongs_to :user
  belongs_to :pillar_category
  
  has_many :event_items, order: 'created_at DESC'
  
  validates :user_id,             :presence => true
  validates :pillar_category_id,  :presence => true

  delegate :name, to: :pillar_category

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :image_url, :name
    options[:include] = :pillar_category, :event_items
    #options[:only] = [:id, :has_attachments]
    hash = super
    hash
  end

  def image_url
    "/assets/pcategories/food.png"
  end
end
