class ProfilesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  def select_pillars
    
    params[:pillar_category].each do |id|
      
      Pillar.create :user_id => current_user.id, :pillar_category_id => id.to_i
      
    end
    
    redirect_to my_profile_path
        
  end
  
  def add_avatar
    
    current_user.profile.avatar = params[:picture]
    
    if current_user.profile.save!
      redirect_to my_profile_path, :notice => 'Avatar has been changed' and return
    else
      redirect_to my_profile_path, :alert => 'Something went wrong, please try again' and return
    end
    
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
