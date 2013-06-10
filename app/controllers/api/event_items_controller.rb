class Api::EventItemsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json
  def index

  end
  def create
    @pillar = current_user.profile.pillars.find(params[:pillar_id])


    @event_item = @pillar.event_items.build(event_params)
    authorize! :create, @event_item
    if @event_item.save
      render json: {event_item: @event_item, pillar_photos: @pillar.event_photos}, scope: :self
    else
      render json: {errors: @event_item.errors}, status: :unprocessable_entity
    end
  end

  def update
    @pillar = current_user.profile.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.find(params[:id])

    if @event_item.update_attributes(event_params)
      render json: {event_item: @event_item, pillar_photos: @pillar.event_photos}, scope: :self
    else
      render json: {errors: @event_item.errors}, status: :unprocessable_entity
    end

  end

  def destroy
    @event = current_user.profile.event_items.where(id: params[:id]).first
    if @event.destroy
      render json: { message: :ok }
    else
      render json: { message: @event.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    @event_params = {
      event_type_id: params[:event_type][:id],
      event_photo_ids: params[:event_photo_ids]
    }

    EventItem.accessible_attributes.each do |aa|
      @event_params[aa] = params[aa] unless params[aa].blank?
    end

    @event_params
  end
end
