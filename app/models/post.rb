class Post < ActiveRecord::Base
  attr_accessible :title, :alias, :body, :published_at
  
  validates :title, :alias, :body, presence: true
  validates :alias, uniqueness: true
  
  scope :recent, order('created_at desc')
end
