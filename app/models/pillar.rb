class Pillar < ActiveRecord::Base
  belongs_to :profile
  belongs_to :pillar_category
  
  has_many :event_items, order: 'created_at DESC', dependent: :destroy
  
  validates :profile_id, presence: true
  validates :pillar_category_id, presence: true

  delegate :name, :description, to: :pillar_category

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :image_url, :name
    options[:only] = [:id, :pillar_category_id]
    hash = super

    case options[:scope]
      when :self, :profile
        #options[:include] = :pillar_category, :event_items
        hash[:event_items] = event_items.map { |e| e.serializable_hash scope: options[:scope] }
    end



    hash
  end

  def image_url
    "/assets/pcategories/food.png"
  end
end
