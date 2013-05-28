require 'spec_helper'

feature 'Sign up' do
  scenario 'user can sign up with valid credentials' do
    visit '/users/sign_up'

    within '.devise-block' do
      within '#new_user' do
        fill_in 'user_email', with: 'user@example.com'
        fill_in 'user_password', with: 'secret'
        fill_in 'user_password_confirmation', with: 'secret'
        check 'user_terms_of_service'
        click_button 'Free sign up'
      end
    end

    expect(current_path).to eq '/'
    expect(page).to have_content 'confirmation link has been sent to your email address'
  end
end
