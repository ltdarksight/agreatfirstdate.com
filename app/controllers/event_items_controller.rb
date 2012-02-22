class EventItemsController < ApplicationController
  respond_to :json, :html

  def create
    @pillar = profile.pillars.find(params[:pillar_id])
    @event_item = @pillar.event_items.build(params[:event_item])
    authorize! :create, @event_item
    @event_item.save
    render json: @event_item, scope: :self
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
    @state = @event_item.update_attributes(params[:event_item])
    render json: @event_item, scope: :self
  end

  def profile
    @profile ||= current_user.profile
  end
  helper_method :profile
end
