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
