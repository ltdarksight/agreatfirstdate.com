module ActsAsEstimable
  def acts_as_estimable(options)
    raise ArgumentError, "Argument :profile is mandatory" unless options.has_key?(:profile)

    include ActsAsEstimable::InstanceMethods

    define_method :limit do
      options[:limit]
    end

    define_method :estimate_for do
      raise "ActsAsEstimable: Define #{options[:profile]} method in #{class_name}" unless respond_to?(options[:profile])
      send(options[:profile])
    end

    after_create :create_point, options
    after_destroy :destroy_point
  end

  module InstanceMethods
    def create_point
      return if limit && estimate_for.point_tracks.today.where(subject_type: class_name).count >= limit
      Point.create(profile: estimate_for, subject_id: id, subject_type: class_name)
    end

    def destroy_point
      Point.destroy_all(profile_id: estimate_for.id, subject_id: id, subject_type: class_name)
    end

    def class_name
      self.class.name
    end
  end
end

ActiveRecord::Base.send :extend, ActsAsEstimable
