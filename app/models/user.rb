class User < ActiveRecord::Base
  ROLES = %w[admin user]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :terms_of_service
  attr_accessor :without_profile

  has_one  :profile, dependent: :destroy

  after_create :create_user_profile
  before_update :track_login_count, if: :sign_in_count_changed?
  after_update :track_weeks_count, if: :sign_in_count_changed?
  
  validates_acceptance_of :terms_of_service

  ROLES.each do |r|
    define_method("#{r}?") { role == r }
  end

  def self.find_or_create_for_facebook(response)
    data = response.info
    where(:email => data.email).first_or_initialize(:password => Devise.friendly_token[0,20]).tap do |user|
      user.confirmed_at = Time.now if user.new_record?
      user.facebook_token = response.credentials.token
      user.facebook_id = response.uid
      user.save
    end
  end

  def soft_delete
    update_attribute(:deleted_at, DateTime.now)
    profile.update_attribute(:status, :locked)
  end

  def active_for_authentication?
    super && !deleted_at
  end
  
  def facebook_albums
    albums = []
    if facebook_token
      graph = Koala::Facebook::API.new(facebook_token)
      albums = graph.get_object("me/albums")
    end
    albums
  end

  private
  def create_user_profile
  # profile = create_profile(profile_settings)
    create_profile(who_am_i: '', who_meet: '') unless without_profile
  end

  def track_login_count
    self.today_sign_in_count = last_sign_in_at && last_sign_in_at.today? ? today_sign_in_count + 1 : 1

    if today_sign_in_count >= 3 && profile.point_tracks.today.where(subject_type: 'Session').empty?
      Point.create(profile: profile, subject_type: 'Session')
    end
  end

  def track_weeks_count
    if profile.point_tracks.where(subject_type: 'Week').where(Point.arel_table[:created_at].gt(DateTime.now - 1.week)).empty? && created_at < DateTime.now - 1.week
      Point.create(profile: profile, subject_type: 'Week')
    end
  end
end
