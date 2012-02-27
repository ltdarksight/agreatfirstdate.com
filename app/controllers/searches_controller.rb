class SearchesController < ApplicationController
  respond_to :html, :json

  def index
    @profile_completed = if user_signed_in?
      @profile = current_user.profile
      @profile.pillars.count == 4
    else
      @profile = Profile.new({
        looking_for: cookies[:looking_for],
        gender: cookies[:gender],
        in_or_around: cookies[:in_or_around],
        looking_for_age: cookies[:looking_for_age]
      })
      false
    end
    respond_to do |format|
      format.html do
        @opposite_sex_results = Profile.where(gender: @profile.looking_for).limit 9
      end
      format.json do
        @results = Profile.where(id: Profile.connection.select_all(Profile.search_conditions(params)).map {|profile| profile['id']})
        if @profile_completed
          @results = @results.paginate page: params[:page], per_page: 5
        else
          @results = @results.limit(user_signed_in? ? 5 : 3).order('RANDOM()')
        end
        render json: format_response_data(@results)
      end
    end
  end

  def opposite_sex
    respond_to do |format|
      @results = Profile.where(gender: params[:gender]).limit 9
      format.json do
        render json: @results
      end
    end
  end

  private

  def format_response_data(results)
    {results: results.map{|r| r.serializable_hash(scope: :search_results)}, page: params[:page]||1, total_entries: @profile_completed ? results.total_entries : results.size}
  end
end
