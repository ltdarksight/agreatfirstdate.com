class User < ActiveRecord::Base
  ROLES = %w[admin user]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable, :omniauthable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessor :without_profile

  has_one  :profile, dependent: :destroy

  after_create :create_user_profile
  after_update :track_login_count, if: :sign_in_count_changed?
  after_update :track_weeks_count, if: :sign_in_count_changed?

  ROLES.each do |r|
    define_method("#{r}?") { role == r }
  end

  def soft_delete
    update_attribute(:deleted_at, DateTime.now)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  private
  def create_user_profile
  # profile = create_profile(profile_settings)
    create_profile(who_am_i: '', who_meet: '') unless without_profile
  end

  def track_login_count
    if sign_in_count > 1 && profile.point_tracks.today.where(subject_type: 'Session').count < 3
      Point.create(profile: profile, subject_type: 'Session')
    end
  end

  def track_weeks_count
    if profile.point_tracks.where(subject_type: 'Week').where(Point.arel_table[:created_at].gt(DateTime.now - 1.week)).empty? && created_at < DateTime.now - 1.week
      Point.create(profile: profile, subject_type: 'Week')
    end
  end
end
