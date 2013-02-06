class Api::ProfilesController < ApplicationController
  respond_to :json
  
  def index
    profiles = Profile.all
    respond_with profiles
  end
  
  def show
    profile = Profile.find(params[:id])
    respond_with profile
  end
  
  def update
    profile = Profile.find(params[:id])
    attrs_available = ['who_am_i', 'who_meet']
    attrs_for_update = {}
    params.map {|key,value| attrs_for_update.merge!({key => params[key]}) if(attrs_available.include? key)}
    puts attrs_for_update.to_yaml
    profile.update_attributes(attrs_for_update)
    render :json => profile, :status => 200
  end
end