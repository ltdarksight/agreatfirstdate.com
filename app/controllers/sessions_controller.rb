class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(auth_options)
    if params[:user][:connect_facebook] && session[:omniauth]
      resource.apply_omniauth(session[:omniauth])
      resource.save!
    end
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
