class Api::V1::EventsController < Api::V1::BaseController
  def show
    render json: EventItem.find(params[:id]).to_json, status: 200
  end

  def create
    event_item = current_user.profile.event_items.new(params[:event_item])
    if event_item.save
      render json: event_item.to_json, scope: :self
    else
      render json: {errors: event_item.errors}, status: :unprocessable_entity
    end
  end

  def update
    event_item = current_user.profile.event_items.find(params[:id])

    if event_item.update_attributes(params[:event_item])
      render json: event_item.to_json, scope: :self
    else
      render json: {errors: event_item.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    event = current_user.profile.event_items.find(params[:id])
    if event.destroy
      render json: { message: :ok }
    else
      render json: { errors: event.errors }, status: :unprocessable_entity
    end
  end
end