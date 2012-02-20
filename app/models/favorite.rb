class Favorite < ActiveRecord::Base
  belongs_to :profile
  belongs_to :favorite, class_name: 'Profile'

  validates :profile_id, uniqueness: {scope: :favorite_id}
end
