class Api::GeoLookupController < ApplicationController
  before_filter :authenticate_user!

  def index
    render :json => {}, :status => 404 and return if params[:zip].blank?
    geo = GeoKit::Geocoders::MultiGeocoder.multi_geocoder "#{params[:zip]}"

    if geo.success && geo.state && geo.city
      render :json =>  {:state => geo.state, :city => geo.city}
    else
      render :json => {}, :status => 404
    end
  end
end
