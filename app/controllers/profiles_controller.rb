class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  
  def select_pillars
    current_user.pillar_category_ids = params[:user_pillar][:pillar_category_ids]
    render json: {pillars: current_user.pillars}
  end
  
  def settings
    @profile = current_user.profile
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end
  
  def me
    @profile = current_user.profile
    @pillars = current_user.pillars
    @pillar_categories = PillarCategory.all
    #TODO
    # I think we need to ask client is this randomizing is what he wants
    #@pillars = @pillars.sort_by {rand}
    @event_item = EventItem.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
    
  end
  
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  def edit
    @profile = current_user.profile
    
    if current_user.sign_in_count == 1
      @profile.gender          = cookies[:i_am_a]
      @profile.looking_for     = cookies[:looking_for]
      @profile.in_or_around    = cookies[:in_or_around]
      @profile.looking_for_age = cookies[:looking_for_age]
      @profile.save
      cookies.delete :i_am_a
      cookies.delete :looking_for
      cookies.delete :in_or_around
      cookies.delete :looking_for_age
    end
  end

  def update
    @profile = current_user.profile
    respond_to do |format|
      if @state = @profile.update_attributes(params[:profile].keep_keys([:who_am_i, :who_meet, :avatars_attributes, :gender, :looking_for_age, :first_name, :last_name, :age, :looking_for, :favorites_attributes]))
        format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        format.json { render json: @profile }
        format.js {  } # avatar upload
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end
end
