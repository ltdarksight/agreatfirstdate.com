class WelcomeController < ApplicationController
  
  def index
    redirect_to my_profile_path if user_signed_in?
  end

  def about
  end

  def blog
  end

  def faq
  end

  def privacy
  end

  def terms
  end
end
