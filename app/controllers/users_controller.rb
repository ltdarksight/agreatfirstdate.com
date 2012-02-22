class UsersController < ApplicationController
  def store_settings
    # This action stores user's info from first registration step into cookies
    # After that user is redirected to second, devise based sign up step

    cookies[:looking_for]     = params[:looking_for]
    cookies[:gender]          = params[:gender]
    cookies[:in_or_around]    = params[:in_or_around]
    cookies[:looking_for_age] = params[:looking_for_age]
    
    redirect_to searches_path#, :notice => 'Thank you! Now you need to create an account.'
  end
end
