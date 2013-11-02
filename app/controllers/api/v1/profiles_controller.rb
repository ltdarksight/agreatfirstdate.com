class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_user.profile, scope: :self_api, status: 200
  end

  def me_update
    profile = current_user.profile
    authorize! :update, profile

    if profile.update_attributes(params[:profile])
      render json: profile, scope: :self
    else
      render json: {errors: profile.errors}, status: :unprocessable_entity
    end
  end

  def show
    render json: Profile.active.find_obfuscated(params[:id]), status: 200
  end
end