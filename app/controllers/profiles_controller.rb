class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def activate
    authorize! :activate, profile
    InappropriateContent.destroy_all(content_id: profile.id, content_type: profile.class.name)
    profile.reload
    render json: profile, scope: :profile
  end

  def deactivate
    authorize! :deactivate, profile
    InappropriateContent.create(content: profile, reason: params[:reason])
    profile.reload
    render json: profile, scope: :profile
  end

  def still_inappropriate
    authorize! :deactivate, profile
    profile.inappropriate_content.update_attribute(:status, :active)
    profile.reload
    render json: profile, scope: :profile
  end

  def show
    authorize! :view, profile
    if my_profile != profile && profile.point_tracks.today.where(subject_id: my_profile.id, subject_type: my_profile.class.name).empty?
      Point.create(subject: my_profile, profile: profile)
    end
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
  
  def facebook_albums
    render json: current_user.facebook_albums if current_user.facebook_token
  end

  def profile
    @profile ||= Profile.active.find(params[:id])
  end
  helper_method :profile

  def my_profile
    @my_profile ||= current_user.profile
  end
  helper_method :my_profile
end
