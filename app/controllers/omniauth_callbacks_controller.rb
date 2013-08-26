class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook env["omniauth.auth"]

    if @user
      if current_user && current_user != @user

        if env['omniauth.params']['popup_photo']
          render 'callback_account_is_linked', :layout => false
        else
          flash[:alert] = "Oops! Your Facebook account is linked to another profile. Please sign out of Facebook and try again."
          redirect_to "/me#unlinked-facebook"
        end

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
      if current_user
        current_user.apply_omniauth!(session[:omniauth])
        @after_sign_in_url = edit_profile_path

        if env['omniauth.params']['popup_photo']
          render 'callback_photo', :layout => false
        else
          redirect_to @after_sign_in_url
        end

      else
        if session[:omniauth][:info] && (@user = User.create_from_facebook(session[:omniauth]))
          flash.notice = I18n.t("devise.registrations.signed_up")
          sign_in(:user, @user)
          @after_sign_in_url = edit_profile_path

          if env['omniauth.params']['popup']
            render 'callback', :layout => false
          else
            redirect_to @after_sign_in_url
          end

        else
          @after_sign_in_url = users_confirm_email_path
          if env['omniauth.params']['popup']
            render 'callback', :layout => false
          else
            redirect_to @after_sign_in_url
          end
        end
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
