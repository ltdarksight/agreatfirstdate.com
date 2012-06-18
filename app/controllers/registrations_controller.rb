class RegistrationsController < Devise::RegistrationsController
  
  layout "welcome", :only => [:create, :confirm_email]
  
  def confirm_email
    resource = build_resource({:email => session[:omniauth][:info][:email]})
    respond_with resource
  end
  
  def new
    session[:omniauth] = nil
    super
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
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end
