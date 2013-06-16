class Api::FavoritesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # list favorites
  def index
    render json: profile.favorite_users
  end

  # add to my favorites
  def create
    @favorite = profile.favorites.create( favorite: Profile.where(id: params[:favorite_id]).first )
    respond_with @favorite, location: api_favorites_path
  end

  # remove from my favorites
  def destroy
    profile.favorites.where(favorite_id: params[:id]).first.try(:destroy)
    render json: 'true', status: 200
  end

  private
  def profile
    @profile ||= current_user.profile
  end

end
