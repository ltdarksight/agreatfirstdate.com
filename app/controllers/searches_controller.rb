class SearchesController < ApplicationController
  respond_to :html, :json

  def index
    if user_signed_in?
      @profile = current_user.profile
    else
      @profile = Profile.new({
        looking_for: cookies[:looking_for],
        gender: cookies[:gender],
        in_or_around: cookies[:in_or_around],
        looking_for_age: cookies[:looking_for_age]
      })
    end
    respond_to do |format|
      format.html do
        @opposite_sex_results = format_response_data Profile.where(gender: @profile.looking_for).paginate page: params[:page], per_page: 5
      end
      format.json do
        @results = Profile.where(id: Profile.connection.select_all(Profile.search_conditions(params)).map {|profile| profile['id']})
        @results = @results.paginate page: params[:page], per_page: 5
        render json: format_response_data(@results)
      end
    end
  end

  def opposite_sex
    respond_to do |format|
      @results = Profile.where(gender: params[:gender]).paginate page: params[:page], per_page: 5
      format.json do
        render json: format_response_data(@results)
      end
    end
  end

  private

  def format_response_data(results)
    {results: results.map{|r| r.serializable_hash(scope: :search_results)}, page: params[:page]||1, total_entries: results.total_entries}
  end
end
