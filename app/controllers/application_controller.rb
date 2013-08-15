class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :profile
  helper_method :current_profile

  before_filter :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to searches_path, alert: exception.message
  end

  def current_profile
    current_user.try(:profile)
  end

  protected
  def authenticate_admin!
    unless authenticate_user! && current_user.admin?
      flash[:error] = "unauthorized access"
      redirect_to root_path
    end
  end

  def check_profile_data
    if profile.invalid?
      flash.notice = "Give us some basic information, then create your profile. You'll be searching in less than 2 minutes!"
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
