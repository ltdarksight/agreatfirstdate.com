class EventPhotosController < ApplicationController
  before_filter :authenticate_user!
  def create
    @event_photo = current_user.profile.event_photos.new(params[:event_photo])
    @event_photo.save
    respond_to do |format|
      format.js
    end
  end
end