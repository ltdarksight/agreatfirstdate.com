class Strike < ActiveRecord::Base
  belongs_to :profile
  belongs_to :striked, class_name: 'Profile'
  scope :today, -> {where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:only] = [:id, :striked_id, :created_at]
    super
  end
end
