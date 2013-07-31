class SearchesController < ApplicationController
  require 'securerandom'
  respond_to :html, :json

  def index
    if params.has_key? :looking_for_age
      params[:looking_for_age_from], params[:looking_for_age_to] = params[:looking_for_age].to_s.split("-")
    end

    @profile, @search_cache, @profile_completed =
      Search.get_data(current_user, params, session, cookies)

    respond_to do |format|
      format.html do
        @opposite_sex_results = Profile.active.where(gender: @profile.looking_for).limit 9
      end
      format.json do
        @limit = 3 if !user_signed_in? || !@profile.card_verified?
        @limit ||= 5 if !@profile_completed
        result_ids = @search_cache.result_ids.clone
        result_ids = Profile.connection.select_all(Profile.search_conditions(params, current_user, @limit, result_ids)).map {|profile| profile['id']}

        @results = Profile.active.where(id: result_ids)

        if @limit
          @search_cache.result_ids = result_ids if result_ids.size > @search_cache.result_ids.size
          @search_cache.save!
        else
          @results = @results.paginate page: params[:page], per_page: 5
        end
        render json: format_response_data(@results)
      end
    end
  end

  private
  def format_response_data(results)
    {results: results.map{|r| r.serializable_hash(scope: :search_results)},
      page: params[:page] || 1,
      total_entries: @profile_completed && @profile.card_verified? ? results.total_entries : results.size}
  end
end
