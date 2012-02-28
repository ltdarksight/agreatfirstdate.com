class Strike < ActiveRecord::Base
  belongs_to :profile
  belongs_to :striked, class_name: 'Profile'

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:only] = [:id, :striked_id]
    super
  end
end
