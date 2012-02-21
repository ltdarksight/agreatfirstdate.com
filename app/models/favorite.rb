class Favorite < ActiveRecord::Base
  belongs_to :profile
  belongs_to :favorite, class_name: 'Profile'

  validates :profile_id, uniqueness: {scope: :favorite_id}

  validate :restrict_for_myself

  def restrict_for_myself
    errors[:base] << "can't add yourself" if profile_id == favorite_id
  end
end
