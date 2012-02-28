class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json
  def select_pillars
    profile.pillar_category_ids = params[:user_pillar][:pillar_category_ids]
    render json: {pillars: profile.pillars.map {|p| p.serializable_hash(scope: :self) }}
  end
  
  def settings
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def me
    @pillars = profile.pillars
    @pillar_categories = PillarCategory.all
    #TODO
    # I think we need to ask client is this randomizing is what he wants
    #@pillars = @pillars.sort_by {rand}
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def show
    @me = current_user.profile
    @profile = Profile.find(params[:id])
    @pillars = @profile.pillars
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def send_email
    @profile = Profile.find(params[:id])
    @email = Email.new(params[:email].keep_keys([:subject, :body]).merge(sender: current_user, recipient: @profile.user))
    authorize! :create, @email
    if @email.save
      render json: current_user.profile, scope: :self
    else
      render json: {errors: @email.errors}, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.sign_in_count == 1
      profile.gender          ||= cookies[:i_am_a]
      profile.looking_for     ||= cookies[:looking_for]
      profile.in_or_around    ||= cookies[:in_or_around]
      profile.looking_for_age ||= cookies[:looking_for_age]
      profile.save
      cookies.delete :i_am_a
      cookies.delete :looking_for
      cookies.delete :in_or_around
      cookies.delete :looking_for_age
    end
  end

  def update
    respond_to do |format|
      if @state = profile.update_attributes(params[:profile].keep_keys([:who_am_i, :who_meet, :avatars_attributes, :gender, :looking_for_age, :first_name, :last_name, :age, :looking_for, :favorites_attributes, :address, :zip, :card_number]))
        format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        format.json { render json: profile, scope: :self }
        format.js {  } # avatar upload
      else
        format.html { render action: "edit" }
        format.json { render json: profile.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  def profile
    @profile ||= current_user.profile
  end
  helper_method :profile
end
