class Api::PillarCategoriesController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json


  def update
    @mutator = Profile::UpdatePillarCategories.new(profile,  params[:pillar_category].try(:[], :ids))

    if @mutator.valid? && @mutator.execute!
      @response = { json: profile.pillars, status: :ok }
    else
      @response = error_response @mutator.errors.join(", ")
    end
    render @response
  end

  private

  def error_response(error_message = "")
     { json: { errors: error_message }, status: :unprocessable_entity }
  end

end
