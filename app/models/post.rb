class Post < ActiveRecord::Base
  attr_accessible :title, :alias, :body
  
  validates :title, :alias, :body, presence: true
  validates :alias, uniqueness: true
end
