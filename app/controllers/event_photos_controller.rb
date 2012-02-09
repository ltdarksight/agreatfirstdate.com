class EventPhotosController < ApplicationController
  def create
    @event_photo = current_user.event_photos.new(params[:event_photo])
    respond_to do |format|
      if @event_photo.save
        format.js
      else
        logger.debug @event_photo.errors.inspect
      end
    end
  end
end