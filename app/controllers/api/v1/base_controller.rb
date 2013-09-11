class Api::V1::BaseController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  before_filter :authenticate_user!

  respond_to :json

  rescue_from CanCan::AccessDenied do |exception|
    render json: exception.message, status: 403
  end
end