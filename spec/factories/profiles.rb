# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    user_id 1
    who_am_i "MyText"
    first_name "MyString"
    last_name "MyString"
    gender "MyString"
    looking_for "MyString"
    in_or_around "MyString"
    age "MyString"
  end
end
