class EventPhotosController < ApplicationController
  before_filter :authenticate_user!
  def create
    event_photos = Array.wrap(params[:event_photo][:image]).map do |image|
      current_user.profile.event_photos.create params[:event_photo].merge(:image => image)
    end

    remote_event_photos = Array.wrap(params[:event_photo][:remote_image_url]).map do |remote_image_url|
      current_user.profile.event_photos.create params[:event_photo].merge(:remote_image_url => remote_image_url)
    end

    @event_photos = event_photos + remote_event_photos

    respond_to do |format|
      format.js
    end
  end
end
