class Api::PillarsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json
  
  
  def index
    respond_with current_user.profile.pillars
  end
end