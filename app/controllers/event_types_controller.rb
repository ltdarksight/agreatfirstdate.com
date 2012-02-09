class EventTypesController < ApplicationController
  respond_to :json
  def index
    respond_with(current_user.pillars.find(params[:pillar_id]).pillar_category.event_types)
  end
end