class Api::V1::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, only: [:create]

  before_filter :ensure_params_exist, only: :create

  respond_to :json

  def_param_group :user do
    param :user, Hash, :required => true, :action_aware => true do
      param :name, String, "Name of the user"
    end
  end

  api :POST, "/users", "Create a session"
  param_group :user
  def create
    build_resource
    resource = User.find_for_database_authentication(:email=>params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      resource.ensure_authentication_token!
      render json: {success: true, auth_token: resource.authentication_token, email: resource.email}
      return
    end
    invalid_login_attempt
  end

  api :DELETE, "/users", "Destroy a session"
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