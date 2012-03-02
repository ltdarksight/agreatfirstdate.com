class AvatarsController < ApplicationController
  before_filter :authenticate_user!
  def update
    @avatar = current_user.profile.avatars.find(params[:id])
    authorize! :update, @avatar
    @avatar.update_attributes params[:avatar].keep_keys([:bounds])
    render json: @avatar, scope: :self
  end
end