class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :avatars
  accepts_nested_attributes_for :avatars, allow_destroy: true

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:include] ||= []
    options[:include] += [:avatars]
    super
  end
end
