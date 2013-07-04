class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook env["omniauth.auth"]
    flash[:notice] = "Signed in with Facebook successfully"
    if @user
      sign_in_and_redirect @user, :event => :authentication
    else
      session[:omniauth] = env['omniauth.auth']
      redirect_to users_confirm_email_path
    end
  end

  def instagram
    current_user.instagram_token = env['omniauth.auth']['credentials']['token']
    current_user.instagram_id = env['omniauth.auth']['credentials']['token']
    current_user.save

    sign_in_and_redirect current_user, :event => :authentication
  end

  def passthru
    render_404
  end
end
