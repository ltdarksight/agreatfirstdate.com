class MyProfileController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_profile_data, :only => :show
  respond_to :html, :json

  def select_pillars
    if profile.set_active_pillars params[:user_pillar][:selected_pillar_ids]
      render json: {pillars: profile.reload.pillars.map {|p| p.serializable_hash(scope: :self) }}
    else
      render :status => 404, :json => profile.errors[:pillars]
    end
  end

  def points
    render json: {points: profile.points}
  end

  def geo
    geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder "zip #{params[:zip]}"
    if geo.success && geo.state && geo.city
      render :json =>  {:state => geo.state, :city => geo.city}
    else
      render :json => {}, :status => 404
    end
  end

  def show
    @pillars = profile.pillars
    @pillar_categories = PillarCategory.all
    respond_to do |format|
      format.html { render 'profiles/show' }
      format.json { render json: profile, scope: :self }
    end
  end

  def update
    respond_to do |format|
      if params[:profile][:user_attributes]
        user_attributes = params[:profile][:user_attributes].clone.keep_keys([:current_password, :password, :password_confirmation])
        params[:profile][:user_attributes] = params[:profile][:user_attributes].keep_keys([:email, :id])
      end
      @state = profile.update_attributes(params[:profile].keep_keys(Profile::ACCESSIBLE_ATTRIBUTES))
      unless !user_attributes || user_attributes[:current_password].blank?
        @state &&= profile.user.update_with_password(user_attributes)
      end

      if @state
        profile.reload
        format.html { redirect_to my_profile_path, notice: 'Profile was successfully updated.' }
        format.json { render json: profile, scope: :self }
        format.js {  } # avatar upload
      else
        profile.reload_card_attributes!
        format.html { render action: "edit" }
        format.json { render json: profile.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  def update_billing
    if @state = profile.update_attributes(params[:profile].keep_keys(Profile::CARD_ATTRIBUTES))
      profile.reload
      render json: profile, scope: :settings
    else
      render json: profile.errors, status: :unprocessable_entity
    end
  end
end
