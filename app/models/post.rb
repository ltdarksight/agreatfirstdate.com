class Post < ActiveRecord::Base
  self.per_page = 10
  
  attr_accessible :title, :alias, :body, :published_at
  
  has_many :comments, as: :commentable
  
  validates :title, :alias, :body, presence: true
  validates :alias, uniqueness: true
  
  scope :recent, order('published_at desc')
end
