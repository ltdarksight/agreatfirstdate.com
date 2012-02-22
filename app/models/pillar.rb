class Pillar < ActiveRecord::Base
  belongs_to :profile
  belongs_to :pillar_category
  
  has_many :event_items, order: 'created_at DESC', dependent: :destroy
  
  validates :profile_id, presence: true
  validates :pillar_category_id, presence: true

  delegate :name, :description, :image_url, to: :pillar_category

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:methods] = :image_url, :name
    options[:only] = [:id, :pillar_category_id]
    hash = super

    case options[:scope]
      when :self, :profile
        hash[:event_items] = event_items.map { |e| e.serializable_hash scope: options[:scope] }
    end
    hash
  end
end
