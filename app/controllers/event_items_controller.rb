class EventItemsController < ApplicationController
  def new
    @event_item = current_user.event_items.new
  end

  def create
    @event_item = current_user.event_items.build(params[:event_item])
    authorize! :create, @event_item
    @event_item.save
  end
end
