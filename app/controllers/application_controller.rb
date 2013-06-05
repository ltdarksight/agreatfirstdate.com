class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :profile
  before_filter :set_current_user

  protected
  def authenticate_admin!
    unless authenticate_user! && current_user.admin?
      flash[:error] = "unauthorized access"
      redirect_to root_path
    end
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

  def set_current_user
    User.current_user = current_user
  end

end
