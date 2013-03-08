class Api::EventItemsController < ApplicationController
  before_filter :authenticate_user!
  
  respond_to :json
  
  def create
    @pillar = current_user.profile.pillars.find(params[:pillar_id])
    
    post_params = {
      event_type_id: params[:event_type][:id],
      event_photo_ids: params[:event_photo_ids]
    }
    
    EventItem.accessible_attributes.each do |aa|
      post_params[aa] = params[aa] unless params[aa].blank?
    end
    
    @event_item = @pillar.event_items.build(post_params)
    authorize! :create, @event_item
    if @event_item.save
      render json: {event_item: @event_item, pillar_photos: @pillar.event_photos}, scope: :self
    else
      render json: {errors: @event_item.errors}, status: :unprocessable_entity
    end
  end
end