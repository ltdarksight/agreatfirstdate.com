class Api::AvatarsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def index
    @avatars = current_user.profile.avatars
    render json: @avatars, location: avatars_api_profiles_path, content_type: 'application/json'
  end

  def create
    @avatar = current_user.profile.avatars.new(params[:avatar])
    if @avatar.save
      render json: @avatar, status: 200
    else
      render json: @avatar.errors, status: :unprocessable_entity, location: avatars_api_profiles_path
    end
  end

  def destroy
    @avatar = current_user.profile.avatars.find(params[:id])

    if @avatar.destroy
      render json: @avatar, status: 200
    end
  end

  def update
    @avatar = current_user.profile.avatars.find(params[:id])
    authorize! :update, @avatar

    @avatar.update_attributes params[:avatar].keep_keys([:bounds])
    render json: @avatar.to_json(scope: :self)
  end

end
