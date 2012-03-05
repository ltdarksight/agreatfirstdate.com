Then /^I should see "([^"]*)" error for "([^"]*)"$/ do |error_message, id|
  within "input##{id} + span, select##{id} + span" do
    should have_content error_message
  end
end