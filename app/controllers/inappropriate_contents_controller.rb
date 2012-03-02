class InappropriateContentsController < ApplicationController
  before_filter :authenticate_user!
  def fix
    authorize! :update, inappropriate_content
    inappropriate_content.update_attributes status: :awaiting
    render json: inappropriate_content
  end

  def inappropriate_content
    @inappropriate_content ||= InappropriateContent.find(params[:id])
  end
  helper_method :inappropriate_content
end