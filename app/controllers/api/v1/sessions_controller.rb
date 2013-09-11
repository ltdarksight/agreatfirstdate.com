class Api::V1::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, only: [:create]

  before_filter :ensure_params_exist, only: :create

  respond_to :json

  def create
    build_resource
    resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      resource.ensure_authentication_token!
      puts resource.to_yaml
      render json: {success: true, auth_token: resource.authentication_token, email: resource.email}
      return
    end
    invalid_login_attempt
  end

  def destroy
    sign_out(resource_name)
  end

protected
  def ensure_params_exist
    return unless params[:user].blank?
    render json: {success: false, message: "Missing user parameter"}, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {success: false, message: "Error with your login or password"}, status: 401
  end
end