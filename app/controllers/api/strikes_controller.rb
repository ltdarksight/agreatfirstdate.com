class Api::StrikesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json
  def create
    if current_profile.strikes.can? params[:strike].values
      @strike = Strike.add(current_profile, params[:strike][:striked_id])
    end
    respond_with @strike, location: api_strikes_url
  end
end
