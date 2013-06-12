class Api::ProfilesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message, status: 403
  end

  def index
    profiles = Profile.all
    respond_with profiles
  end

  def show
    user_profile = Profile.find(params[:id])
    if user_profile == current_user.profile
      render :json =>  current_user.profile.to_json(scope: :profile), :status => 200
    else
      render :json =>  user_profile, :status => 200
    end
  end

  def update
    profile = Profile.find(params[:id])
    authorize! :update, profile

    attrs_available = ['who_am_i', 'who_meet', 'pillar_category_ids']
    attrs_for_update = {}
    params.map {|key,value| attrs_for_update.merge!({key => params[key]}) if(attrs_available.include? key)}
    puts attrs_for_update.to_yaml
    profile.update_attributes(attrs_for_update)
    render :json => profile, :status => 200
  end
end
