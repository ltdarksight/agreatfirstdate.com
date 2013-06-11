class Api::Facebook::AlbumsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :need_facebook_connection
  respond_to :json

  def index
    render json: current_user.facebook_albums
  end

  def show
    render json: { photos: current_user.facebook_album(params[:id]) }
  end

  private

  def need_facebook_connection
    unless current_user.facebook_token
      render json: { message: :not_connect , location: omniauth_authorize_path(:user, :facebook) }, status: 422  and return
    end
  end

end
