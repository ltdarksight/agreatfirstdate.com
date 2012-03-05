Given /^I exist in the application as (.*)$/ do |user|
  @current_profile = Factory.create :male,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    who_am_i: Faker::Lorem.paragraph(5),
    who_meet: Faker::Lorem.paragraph(5)
  @current_user = @current_profile.user
end

Given /^I am signed in$/ do
  visit new_user_session_path
  fill_in "Email", with: @current_user.email
  fill_in "Password", with: "123456"
  within("#pageContainer") do
    click_button "Sign in"
  end
  Then %Q{I should be signed in}
end

Given /^I am an authenticated user$/ do
  Given %Q{I exist in the application as quotes provider user}
  When %Q{I am signed in}
end

Given /^I am logged out$/ do
  When %Q{I follow "Sign out"}
end

Then /^I should be signed in$/ do
  within("header") do
    should have_content("Sign out")
  end
end

Then /^I should not be signed in$/ do
  Then %Q{I should not see "Sign out" within "header"}
end