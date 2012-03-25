FactoryGirl.define do
  factory :user do
    email 'user@rubybakers.com'
    password '123456'
    after_build { |u| u.skip_confirmation! }
  end
end
