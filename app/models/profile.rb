class Profile < ActiveRecord::Base

  belongs_to :user
  
  #validates_inclusion_of :gender, :in => %w( male female )
  #validates_inclusion_of :looking_for, :in => %w( men women )
  
end
