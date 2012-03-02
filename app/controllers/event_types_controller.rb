class EventTypesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json
  def index
    render json: current_user.profile.pillars.find(params[:pillar_id]).pillar_category.event_types, scope: :self
  end
end