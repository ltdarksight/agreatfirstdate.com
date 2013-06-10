class Api::StrikesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json
  def create
    @strike = current_user.profile.strikes.create params[:strike]
    respond_with @strike, location: api_strikes_url
  end
end
