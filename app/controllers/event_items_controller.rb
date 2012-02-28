class EventItemsController < ApplicationController
  respond_to :json, :html

  def create
    @pillar = profile.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.build(params[:event_item])
    authorize! :create, @event_item
    if @event_item.save
      render json: {event_item: @event_item, pillar_photos: @pillar.event_photos}, scope: :self
    else
      render json: {errors: @event_item.errors}, status: :unprocessable_entity
    end
  end

  def edit
    @event_item = profile.event_items.find(params[:id])
    authorize! :update, @event_item
    if request.xhr?
      render 'edit', :layout => false and return
    end
  end

  def update
    @pillar = profile.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.find(params[:id])
    authorize! :update, @event_item
    if @event_item.update_attributes(params[:event_item])
      render json: {event_item: @event_item, pillar_photos: @pillar.event_photos}, scope: :self
    else
      render json: {errors: @event_item.errors}, status: :unprocessable_entity
    end
  end

  def profile
    @profile ||= current_user.profile
  end
  helper_method :profile
end
