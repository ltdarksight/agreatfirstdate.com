class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook env["omniauth.auth"]

    if @user
      if current_user && current_user != @user
        flash[:alert] = "Oops! Your Facebook account is linked to another profile. Please sign out of Facebook and try again."
        redirect_to "/me#unlinked-facebook"
      else
        flash[:notice] = "Signed in with Facebook successfully"

        if request.env['omniauth.params']['popup'] #params.has_key? :popup
          sign_in @user, :event => :authentication
          @after_sign_in_url = after_sign_in_path_for(@user)
          render 'callback', :layout => false
        else
          sign_in_and_redirect @user, :event => :authentication
        end
      end

    else
      session[:omniauth] = env['omniauth.auth']

      if env['omniauth.params']['popup']
        @after_sign_in_url = users_confirm_email_path
        render 'callback', :layout => false
      else
        redirect_to users_confirm_email_path
      end
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
