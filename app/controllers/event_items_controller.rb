class EventItemsController < ApplicationController
  respond_to :json, :html

  def index
    @pillar = current_user.pillars.find(params[:pillar_id])
    respond_with @pillar.event_items
  end

  def new
    @event_item = current_user.event_items.new
  end

  def create
    @pillar = current_user.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.build(params[:event_item])
    authorize! :create, @event_item
    @event_item.save
    respond_with @event_item
  end

  def edit
    @event_item = current_user.event_items.find(params[:id])
    authorize! :update, @event_item
    if request.xhr?
      render 'edit', :layout => false and return
    end
  end

  def update
    @pillar = current_user.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.find(params[:id])
    authorize! :update, @event_item
    @state = @event_item.update_attributes(params[:event_item])
    logger.debug @event_item.inspect
    render json: @event_item
  end
end
