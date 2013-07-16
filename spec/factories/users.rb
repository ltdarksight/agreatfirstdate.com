FactoryGirl.define do
  factory :user do
    email 'user@rubybakers.com'
    password '123456'
    after(:build) { |u| u.skip_confirmation! }
    terms_of_service '1'
  end
end
