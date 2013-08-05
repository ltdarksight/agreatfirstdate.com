class Strike < ActiveRecord::Base
  belongs_to :profile
  belongs_to :striked, class_name: 'Profile'
  scope :today, -> {where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }

  def self.add(profile, striked_id)
    strike = self.where(profile_id: profile.id,
                        striked_id: striked_id).first_or_initialize
    strike.strikes_count += 1
    strike.striked_on = Date.current
    strike.save
  end

  def serializable_hash(options = nil)
    options = options ? options.clone : {}
    options[:only] = [:id, :striked_id, :created_at, :strikes_count, :striked_on]
    super
  end
end
