class Api::InstagramController < ApplicationController
  before_filter :authenticate_user!
  before_filter :need_instagram_connection
  respond_to :json

  def index
    opt = {}
    opt[:max_id] = params[:max_id] if params[:max_id]
    render json: current_user.instagram_photos(opt)
  end

  private

  def need_instagram_connection
    unless current_user.instagram_token
      session[:user_return_to] = params[:return_to] if params[:return_to]
      render json: { message: :not_connect , location: omniauth_authorize_path(:user, :instagram) }, status: 422  and return
    end
  end

end
