class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  
  def me
    
    @profile = current_user.profile

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
      
    end
    
  end

  def update
    @profile = current_user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

end
