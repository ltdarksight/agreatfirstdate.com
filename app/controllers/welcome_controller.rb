class WelcomeController < ApplicationController

  def index
    redirect_to my_profile_path if user_signed_in?
  end

  def faq
    respond_to do |format|
      format.html{}
      format.js{ render :layout => false }
    end

  end

  def send_feedback
    @feedback = Feedback.new(params[:feedback].keep_keys([:email, :subject, :body]).merge(user: current_user))
    if @feedback.save
      render json: @feedback
    else
      render json: {errors: @feedback.errors}, status: :unprocessable_entity
    end
  end
end
