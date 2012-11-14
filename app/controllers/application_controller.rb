class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :profile
  
protected
  def authenticate_admin!
    authenticate_user! and current_user.admin?
  end
  
  def check_profile_data
    if profile.invalid?
      flash.notice = "At first, please fill up your profile page"
      redirect_to edit_profile_path
    end
  end

  def profile
    @profile ||= current_user.try :profile
  end

  def render_404
    render 'pages/404', :status => 404
  end
end
