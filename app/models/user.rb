class User < ActiveRecord::Base
  ROLES = %w[admin user]

  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :terms_of_service, :connect_facebook
  attr_accessor :without_profile, :connect_facebook

  has_one  :profile, dependent: :destroy

  after_create :create_user_profile
  before_update :track_login_count, if: :sign_in_count_changed?
  after_update :track_weeks_count, if: :sign_in_count_changed?
  
  validates_presence_of :terms_of_service, :on => :create
  validates_acceptance_of :terms_of_service, :on => :create

  ROLES.each do |r|
    define_method("#{r}?") { role == r }
  end

  def self.find_for_facebook(response)
    where('facebook_id = ? and facebook_token = ?', response.uid, response.credentials.token).first
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
      albums_ids = albums.map{|a| a['cover_pid']}
      cover_photos = graph.fql_query("SELECT aid, src FROM photo WHERE pid IN ("+albums_ids.join(",")+")")
      
      albums.each do |album|
        out[album['aid']] = {aid: album['aid'], name: album['name'], link: album['link'], photo_count: album['photo_count']}
      end
      
      cover_photos.each do |cover_photo|
        out[cover_photo['aid']].merge!({src: cover_photo['src']})
      end
      
      albums_data = out.map{|k, v| v}
    end
    albums_data
  end
  
  def instagram_photos(options = {})
    instagram_options = {:count => 20}.merge(options)
    albums_data = []
    if instagram_token
      client = Instagram.client(:access_token => instagram_token)    
      client.user_recent_media(nil, instagram_options).each do |media|
        albums_data << media.images.merge({:id => media.id})
      end
    end
    
    albums_data
  end
  
  def facebook_album(aid)
    photos = []
    if facebook_token
      graph = Koala::Facebook::API.new(facebook_token)
      photos = graph.fql_query("SELECT src_small, pid, src_big FROM photo WHERE aid="+aid.to_s)
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
