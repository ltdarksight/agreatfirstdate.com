class EventItemsController < ApplicationController
  def new
    @event_item = current_user.event_items.new
  end

  def create
    @event_item = current_user.event_items.build(params[:event_item])
    authorize! :create, @event_item
    @event_item.save
  end

  def edit
    @event_item = current_user.event_items.find(params[:id])
    authorize! :update, @event_item
    if request.xhr?
      render 'edit', :layout => false and return
    end
  end

  def update
    @event_item = current_user.event_items.find(params[:id])
    authorize! :update, @event_item
    @state = @event_item.update_attributes(params[:event_item])
  end
end
