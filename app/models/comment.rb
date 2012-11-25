class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  
  validates :full_name, :body, presence: true
end
