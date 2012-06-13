class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_or_create_for_facebook env["omniauth.auth"]
    flash[:notice] = "Signed in with Facebook successfully"
    sign_in_and_redirect @user, :event => :authentication
  end
  
  def instagram
    @user = User.find_or_create_for_instagram env["omniauth.auth"]
    flash[:notice] = "Signed in with Instagram successfully"
    sign_in_and_redirect @user, :event => :authentication
  end

  def passthru
    render_404
  end
end
