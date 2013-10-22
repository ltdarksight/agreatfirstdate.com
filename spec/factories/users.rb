FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{ n }@example.com" }
    first_name Faker::Name.first_name
    password '123456'
    after(:create) { |u| u.update_column :confirmed_at, Time.current }
    terms_of_service '1'
  end
end
