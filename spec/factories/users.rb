FactoryGirl.define do
  factory :user do
    email 'user@rubybakers.com'
    password '123456'
    after_create { |u|
      u.profile.destroy
    }
  end
end
