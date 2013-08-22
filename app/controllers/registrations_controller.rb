class RegistrationsController < Devise::RegistrationsController
  layout :registration_layout
  def confirm_email

    if params[:user]
      build_resource({:first_name => session[:omniauth][:info].try(:[], :first_name)}.merge(params[:user]))

      if resource.save
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_navigational_format?
          sign_in(resource_name, resource)
          respond_with resource, :location => after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
          expire_session_data_after_sign_in!
          respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource

        respond_with(resource) do |format|
          format.html {
            render (provider_facebook? ? "confirm_facebook" : 'confirm_email')
          }
        end

      end
    else
      resource = build_resource({
                                  :email => session[:omniauth][:info].try(:[], :email),
                                  :first_name => session[:omniauth][:info].try(:[], :first_name)
                                })

      respond_with(resource) do |format|
        format.html {
          render (provider_facebook? ? "confirm_facebook" : 'confirm_email')
        }
      end

    end
  end

  def new
    session[:omniauth] = nil
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path(anchor: 'successful-sign-up')
  end

  # def destroy
  #   resource.soft_delete
  #   set_flash_message :notice, :destroyed
  #   sign_out_and_redirect(resource)
  # end

# protected

  # def build_resource(hash=nil)
  #   hash ||= params[resource_name] || {}
  #   self.resource ||= resource_class.new_with_session(hash, session)
  #   self.resource.profile_settings = cookies.inject({}){ |res, (key, val)|
  #     res[key] = val
  #     res
  #   }.keep_keys([:looking_for, :gender, :in_or_around, :looking_for_age])
  # end

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

protected

  def build_resource(*args)

    super(*args)
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
    end
  end
  def registration_layout
    if action_name =~ /new|create/
      'registration'
    else
      "application"
    end
  end

  def provider_facebook?
    session[:omniauth] && session[:omniauth].provider.to_s == 'facebook'
  end

end
