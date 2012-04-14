MALE_FIRST_NAME = %w[James John Michael Paul Mark Brian Kevin Gary Anthony Peter Ryan Jack Ralph Harry Victor Alan Philip]
FEMALE_FIRST_NAME = %w[Nicole Milla Angela Mary Betty Sharon Jessica Amy Anna Amanda Debra Alice Julie Louise Bonnie]
LAST_NAME = %w[SMITH JOHNSON WILLIAMS JONES BROWN DAVIS MILLER WILSON MOORE TAYLOR ANDERSON THOMAS JACKSON WHITE HARRIS MARTIN THOMPSON GARCIA MARTINEZ ROBINSON CLARK RODRIGUEZ LEWIS]

Factory.sequence(:male_name) do |i|
  "#{MALE_FIRST_NAME[(i-1)%MALE_FIRST_NAME.count]}-#{i}".humanize
end

Factory.sequence(:female_name) do |i|
  "#{FEMALE_FIRST_NAME[(i-1)%FEMALE_FIRST_NAME.count]}-#{i}".humanize
end

Factory.sequence(:last_name) do |i|
  LAST_NAME[(i-1)%LAST_NAME.count].humanize
end

# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :profile do
    user { |p| p.association(:user, email: "#{p.first_name}.#{p.last_name}@rubybakers.com", without_profile: true) }
  end
  factory :male, parent: :profile do
    first_name { Factory.next :male_name }
    last_name { Factory.next :last_name }
    gender 'male'
    looking_for 'female'
    looking_for_age '18-40'
    age { rand(30)+18 }
  end

  factory :female, parent: :profile do
    first_name { Factory.next :female_name }
    last_name { Factory.next :last_name }
    gender 'female'
    looking_for 'male'
    looking_for_age '18-40'
    age { rand(20)+16 }
  end
end
