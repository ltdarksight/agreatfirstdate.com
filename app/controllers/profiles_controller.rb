class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json


  def still_inappropriate
    authorize! :deactivate, profile
    profile.inappropriate_content.update_attribute(:status, :active)
    profile.reload
    render json: profile, scope: :profile
  end

  def show
    authorize! :view, profile
    ChargingPointsPolicy.new(profile, 'Profile', my_profile.id).charge!
    @pillars = profile.pillars
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def send_email
    @email = Email.new(params[:email].keep_keys([:subject, :body]).merge(sender: current_user, recipient: profile.user))
    authorize! :create, @email
    if @email.save
      render json: my_profile, scope: :self
    else
      render json: {errors: @email.errors}, status: :unprocessable_entity
    end
  end

  def profile
    @profile ||= (current_user.admin? ? Profile.find_obfuscated(params[:id]) : Profile.active.find_obfuscated(params[:id]))
  end
  helper_method :profile

  def my_profile
    @my_profile ||= current_user.profile
  end
  helper_method :my_profile
end
