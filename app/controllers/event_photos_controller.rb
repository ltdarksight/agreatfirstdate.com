class EventPhotosController < ApplicationController
  before_filter :authenticate_user!
  def create
    @event_photos = Array.wrap(params[:event_photo][:image]).map do |image|
      current_user.profile.event_photos.create params[:event_photo].merge(:image => image)
    end
    respond_to do |format|
      format.js
    end
  end
end
