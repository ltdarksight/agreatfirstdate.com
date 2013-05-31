class Api::AvatarsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    @avatars = current_user.profile.avatars.create(params[:avatars])
    respond_with @avatars, location: avatars_api_profiles_path
  end

  def destroy
    @avatar = current_user.profile.avatars.find(params[:id])
    # authorize! :destroy, @avatar
    if @avatar.destroy
      render json: @avatar, status: 200
    end
  end

  def update
    @avatar = current_user.profile.avatars.find(params[:id])
    authorize! :update, @avatar
    @avatar.update_attributes params[:avatar].keep_keys([:bounds])
    render json: @avatar, scope: :self
  end

end
