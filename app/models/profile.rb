class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :avatars

  accepts_nested_attributes_for :avatars, allow_destroy: true

  validates :who_am_i, length: {maximum: 500}
  validates :who_meet, length: {maximum: 500}

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:include] ||= []
    options[:include] += [:avatars]
    super
  end
end
