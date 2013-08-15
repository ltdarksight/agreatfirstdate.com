class Api::EventPhotosController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  def create
    @event_photos = [ ]
    if params[:event_photo]

      event_photos = Array.wrap(params[:event_photo][:image]).map do |image|
        current_user.profile.event_photos.create params[:event_photo].merge(:image => image)
      end

      remote_event_photos = Array.wrap(params[:event_photo][:remote_image_url]).map do |remote_image_url|
        current_user.profile.event_photos.create params[:event_photo].merge(:remote_image_url => remote_image_url)
      end

      @event_photos << event_photos
      @event_photos << remote_event_photos
    end

    if params[:instagram_photos]
      @instagram_photos = current_user.profile.event_photos.create(params[:instagram_photos].values)
      @event_photos << @instagram_photos
    end

    render :json => @event_photos.flatten, :status => 200
  end
end
