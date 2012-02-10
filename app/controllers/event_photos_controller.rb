class EventPhotosController < ApplicationController
  def create
    @event_photo = current_user.event_photos.new(params[:event_photo])
    @event_photo.save
    respond_to do |format|
      format.js
    end
  end
end