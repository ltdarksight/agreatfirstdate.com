class User < ActiveRecord::Base
  attr_accessible :email, :password,
    :password_confirmation, :remember_me,
    :terms_of_service, :connect_facebook, :first_name

  ROLES = %w[admin user]

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable #, :confirmable


  attr_accessor :without_profile, :connect_facebook, :first_name, :terms_of_service

  has_one  :profile, dependent: :destroy
  after_create :create_user_profile
  after_update :track_login_count, if: :sign_in_count_changed?
  after_update :track_weeks_count, if: :sign_in_count_changed?

  #validates_presence_of :terms_of_service, :on => :create
  # validates_acceptance_of :terms_of_service, :on => :create
  class << self
    def current_user
      Thread.current[:user]
    end

    def current_user=(user)
      Thread.current[:user] = user
    end
  end

  ROLES.each do |r|
    define_method("#{r}?") { role == r }
  end

  def self.find_for_facebook(response)
    where(facebook_id: response.uid).first
  end

  def apply_omniauth(omniauth)
    self.facebook_token = omniauth['credentials']['token']
    self.facebook_id    = omniauth['uid']
    self.password = Devise.friendly_token[0,20] if new_record?
  end

  def soft_delete
    update_attribute(:deleted_at, DateTime.now)
    profile.update_attribute(:status, :locked)
  end

  def active_for_authentication?
    super && !deleted_at
  end

  def facebook_albums
    albums_data = []
    if facebook_token
      out = {}
      graph = Koala::Facebook::API.new(facebook_token)

      albums = graph.fql_query("SELECT aid, name, link, cover_pid, photo_count FROM album WHERE owner=me() AND photo_count > 0")
      cover_pids = albums.map { |a| "'#{ a['cover_pid'] }'" }.join(",")
      cover_photos = graph.fql_query("SELECT aid, src FROM photo WHERE pid IN (#{ cover_pids })")

      albums.each do |album|
        out[album['aid']] = {
          id: album['aid'],
          aid: album['aid'],
          name: album['name'],
          link: album['link'],
          photo_count: album['photo_count']
        }
      end

      cover_photos.each do |cover_photo|
        out[cover_photo['aid']].merge!({src: cover_photo['src']})
      end

      albums_data = out.map{|k, v| v}
    end
    albums_data
  end

  def instagram_photos(options = {})
    instagram_options = {:count => 14}.merge(options)
    albums_data = []
    if instagram_token
      client = Instagram.client(:access_token => instagram_token)
      client.user_recent_media(nil, instagram_options).each do |media|
        albums_data << media.images.merge({:id => media.id})
      end
    end

    albums_data
  end

  def instagram_media(options = {})
    instagram_options = {:count => 14}.merge(options)
    media_data = { photos: [], videos: []}
    if instagram_token
      client = Instagram.client(:access_token => instagram_token)
      media_data = client.user_recent_media(nil, instagram_options)#.each do |media|
        #if media.images
          #media_data[:photos] << media.images.merge({:id => media.id})
        #end
        #if media.videos
         # media_data[:videos] << media.videos.merge({:id => media.id})
        #end
      #end
    end

    media_data
  end

  def facebook_album(aid)
    photos = []
    if facebook_token
      graph = Koala::Facebook::API.new(facebook_token)
      photos = graph.fql_query("SELECT src_small, pid, src_big FROM photo WHERE aid='#{ aid.to_s }'")
    end
    photos
  end

  def serializable_hash(options={})
      options = {
        # :include => {:user => {:only => [:email, :id]},
        :include => [:profile],
        :only => [:id]
      }.update(options)
      super(options)
  end

  def third_sign_in_today?
    self.today_sign_in_count.to_i <= Point::EVENT_LIMITS['Session'] &&
      profile.point_tracks.today.where(subject_type: 'Session').count <= Point::EVENT_LIMITS['Session']
  end

  private
  def create_user_profile
  # profile = create_profile(profile_settings)
    create_profile(who_am_i: '', who_meet: '', first_name: self.first_name) unless without_profile
  end

  def track_login_count
    update_column :today_sign_in_count, current_today_sign_in_count
    ChargingPointsPolicy.new(profile, 'Session').charge!
  end

  def track_weeks_count
    ChargingPointsPolicy.new(profile, 'Week').charge!
  end

  def current_today_sign_in_count
    if last_sign_in_at && last_sign_in_at.today?
      today_sign_in_count.to_i + 1
    else
      1
    end
  end
end
