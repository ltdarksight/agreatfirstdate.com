FactoryGirl.define do
  factory :user do
    email 'user@23ninja.com'
    password '123456'
    after_create { |u|
      u.profile.destroy
    }
  end
end
