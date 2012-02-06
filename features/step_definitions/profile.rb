When /^I signed in as some user$/ do
  visit '/'
  fill_in "user_email",    :with => "user@example.com"
  fill_in "user_password", :with => "123456"
  click_on 'Welcome back'
end

Then /^I should have useful links in page header$/ do
  page.should have_selector('#headerUserTools')
  page.should have_selector('#headerUserPoints')
  
  page.should have_content('Settings')
  page.should have_content('My Profile')
  page.should have_content('Browse Profiles')
  page.should have_content('Sign out')
end
