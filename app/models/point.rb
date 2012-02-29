class Point < ActiveRecord::Base
  EVENT_TYPES = {
    'Pillar' => 25,
    'Avatar' => 25,
    'EventItem' => 25,
    'Favorite' => 10,

    'Email' => 50,
    'Week' => 100,
    'Session' => 15, #Sign In
    'Profile' => 5 #ProfileView
  }
  belongs_to :profile
  belongs_to :subject, polymorphic: true

  after_create :increment_profile_points
  after_destroy :decrement_profile_points

  scope :today, where('DATE(points.created_at) = DATE(NOW())')

  def increment_profile_points
    profile.reload
    profile.increment!(:points, EVENT_TYPES[subject_type])
  end

  def decrement_profile_points
    profile.reload
    profile.decrement!(:points, EVENT_TYPES[subject_type])
  end
end
