class ChargingPointsPolicy
  def initialize(profile, subject_type, subject_id = nil)
    @profile = profile
    @subject_type = subject_type
    @subject_name = subject_type.downcase.to_sym
    @subject_id = subject_id
    @user = profile.user
  end

  def charge!
    if can_be_charged?
      Point.create(profile: @profile,
                   subject_type: @subject_type,
                   subject_id: @subject_id)
    end
  end

  def can_be_charged?
    self.send("#{ @subject_name }_can_be_charged?")
  end

  private
  def session_can_be_charged?
    @user.today_sign_in_count.to_i >= 3 &&
      @profile.point_tracks.today.where(subject_type: 'Session').empty?
  end

  def week_can_be_charged?
    @profile.point_tracks.this_week.where(subject_type: 'Week').empty? &&
      @user.created_at < 1.week.ago
  end

  def profile_can_be_charged?
    @subject_id != @profile.id &&
      @profile.point_tracks.today.where(subject_id: @subject_id, subject_type: 'Profile').empty?
  end
end
