def stripe_hook(token, type)
  post(stripe_web_hook_url, {type: type, data:{object: {customer: token, id: token}}}, {"Content-Type" => "application/json"})
end

When /^I go to the edit my profile page$/ do
  visit edit_profile_path
end

When /^I fill in my card details$/ do
  fill_in 'Card number', with: '424242424242424'
  Then %{I should see "invalid card number" error for "profile_card_number"}
  Then %{I should see "can't be blank" error for "profile_card_type"}
  Then %{I should see "can't be blank" error for "profile_card_expiration"}
  Then %{I should see "can't be blank" error for "profile_card_cvc"}
  fill_in 'Card number', with: '4444-4444-4444-4444'

  fill_in 'Expiration', with: '23/10'
  Then %{I should see "invalid date" error for "profile_card_expiration"}
  fill_in 'Expiration', with: '02/10'

  select 'VISA / VISA CLASSIC', for: 'Card Type'

  fill_in 'CVC code', with: '77777'
  Then %{I should see "invalid CVC" error for "profile_card_cvc"}
  fill_in 'CVC code', with: '777'

  within "#edit_profile" do
    should have_content 'Verify'
    click_link 'Verify'
  end
  Then %{I should see "number is incorrect" error for "profile_card_number"}
  fill_in 'Card number', with: '4242-4242-4242-4242'
  click_link 'Verify'
  Then %{I should see "expiration year is invalid" error for "profile_card_expiration"}
  fill_in 'Expiration', with: '02/20'

end

When /^I verify my card$/ do
  within "#edit_profile" do
    should have_content 'Verify'
    click_button 'Save'
  end
  within "#edit_profile" do
    should have_content 'Change Card Details'
  end
  page.should have_content 'I would totally have also added these categories too'
  URI.parse(current_url).path.should == my_profile_path
  @current_profile.reload
  @current_profile.should_not be_card_verified
  stripe_hook @current_profile.stripe_customer_token, 'customer.created'
  @current_profile.reload
  @current_profile.should_not be_card_verified
  stripe_hook @current_profile.stripe_customer_token, 'customer.subscription.created'
  @current_profile.reload
  @current_profile.should_not be_card_verified
  stripe_hook @current_profile.stripe_customer_token, 'invoice.created'
  @current_profile.reload
  @current_profile.should be_card_verified
  stripe_hook @current_profile.stripe_customer_token, 'invoice.payment_failed'
  @current_profile.reload
  @current_profile.should_not be_card_verified

end