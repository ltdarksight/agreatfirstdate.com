class Api::PillarsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json


  def index
    render :json =>  current_user.profile.pillars.to_json(scope: :profile), :status => 200
  end
end
