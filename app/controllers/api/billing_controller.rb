class Api::BillingController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message, status: 403
  end

  def show

  end

  def update
    @profile = current_user.profile
    @profile.attributes = params[:profile]

    if @profile.save_with_payment
      render json: @profile, scope: :settings
    else
      render json: @profile.errors, status: :unprocessable_entity
    end

  end



end
