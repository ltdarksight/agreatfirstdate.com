class SearchesController < ApplicationController
  respond_to :html, :json

  def index
    @profile = current_user.profile
    @results = Profile.find_all_by_id Profile.connection.select_all(Profile.search_conditions(params)).map {|profile| profile['id']}
    respond_to do |format|
      format.html {}
      format.json { render json: @results, scope: :search_results }
    end

  end
end
