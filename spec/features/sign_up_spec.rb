require 'spec_helper'

feature 'Sign up' do
  scenario 'user can sign up with valid credentials' do
    visit '/users/sign_up'

    within '.reg_popup' do
      within '#new_user' do
        fill_in 'user_email', with: 'user@example.com'
        fill_in 'user_password', with: 'secret'
        # fill_in 'user_password_confirmation', with: 'secret'
        # check 'user_terms_of_service'
        click_button 'Sign up'
      end
    end

    expect(current_path).to eq '/me/edit'
    expect(page).to have_content 'Give us some basic information, then create your profile. You\'ll be searching in less than 2 minutes!'
  end
end
