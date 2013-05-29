class Api::FavoritesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  # list favorites
  def index
    render json: profile.favorites
  end

  # add to my favorites
  def create
    @user = User.where(id: params[:id]).first
    if @user && profile.favorites << @user
      render json: @user
    else
      render json: {errors: 'user not found'}
    end

  end

  # remove from my favorites
  def destroy
    profile.favorites.find(params[:id]).try(:destroy)
    render json: 'true', status: 200
  end

  private
  def profile
    @profile ||= current_user.profile
  end

end
