class Point < ActiveRecord::Base
  attr_accessible :profile, :subject_type, :subject_id, :subject

  EVENT_TYPES = {
    'Pillar' => 25,
    'Avatar' => 25,
    'EventItem' => 25,
    'Favorite' => 3,

    'Email' => 50,
    'Week' => 100,
    'Session' => 10, # Sign In
    'Profile' => 1 # ProfileView
  }

  EVENT_LIMITS = {
    'Session' => 3
  }

  belongs_to :profile
  belongs_to :subject, polymorphic: true

  after_create :increment_profile_points
  after_destroy :decrement_profile_points

  scope :today, -> { where('DATE(points.created_at) = ?', Date.current) }
  scope :this_week, -> { where('points.created_at > ?', 1.week.ago) }

  private
  def increment_profile_points
    profile.reload
    profile.increment!(:points, EVENT_TYPES[subject_type])
  end

  def decrement_profile_points
    profile.reload
    profile.decrement!(:points, EVENT_TYPES[subject_type])
  end
end
