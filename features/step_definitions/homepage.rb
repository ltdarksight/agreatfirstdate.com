Given /^I have some user$/ do
  user = create(:user)
  user.confirmed_at = Time.now
  user.save
end

When /^I go to home page$/ do
  visit '/'
end

Then /^I should see "([^"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^Page should have "([^"]*)"$/ do |arg1|
  page.should have_selector(arg1)
end

When /^I enter right credentials in sign in form$/ do
  fill_in "user_email",    :with => "user@example.com"
  fill_in "user_password", :with => "123456"
end

When /^I enter wrong credentials in sign in form$/ do
  fill_in "user_email",    :with => "wrong@email.com"
  fill_in "user_password", :with => "1235456"
end

When /^I click "([^"]*)" button$/ do |btn|
  click_on btn
end

# TODO
# Make this two steps one with regexp for page
Then /^I should get in my profile page$/ do
  current_path.should == my_profile_path
end

Then /^I should not get in my profile page$/ do
  current_path.should_not == my_profile_path
end

Then /^I sign out$/ do
  visit '/users/sign_out'
end
