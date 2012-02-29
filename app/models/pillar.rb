class Pillar < ActiveRecord::Base
  acts_as_estimable profile: :profile

  belongs_to :profile, counter_cache: true
  belongs_to :pillar_category
  
  has_many :event_items, order: 'created_at DESC', dependent: :destroy
  has_many :event_photos, through: :event_items

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
        hash[:event_photos] = event_photos.limit(10).map { |e| e.serializable_hash scope: options[:scope] }
      when :search_results
        hash[:image_url] = event_photos.order('RANDOM()').first.image.pillar.url if event_photos.any?
    end
    hash
  end
end
