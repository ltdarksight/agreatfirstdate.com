class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_one  :profile, :dependent => :destroy

  after_create :create_user_profile
  
  private
    def create_user_profile
      # TODO
      # Now we only create empty profile
      # After we implement registration first step we should push some info into created profile
      profile = Profile.create :user_id => self.id
    end
end
