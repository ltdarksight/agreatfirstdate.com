class SearchCache < ActiveRecord::Base
  belongs_to :profile

  serialize :result_ids, Array
  serialize :pillar_ids, Array

  scope :guest_caches, where(profile_id: nil)
end
