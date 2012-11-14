class Post < ActiveRecord::Base
  
  validates :title, :alias, :body, presence: true
  validates :alias, uniqueness: true
end
