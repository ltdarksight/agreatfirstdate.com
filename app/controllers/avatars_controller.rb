class AvatarsController < ApplicationController
  def update
    @avatar = current_user.profile.avatars.find(params[:id])
    @avatar.update_attributes params[:avatar].keep_keys([:bounds])
    render json: @avatar
  end
end