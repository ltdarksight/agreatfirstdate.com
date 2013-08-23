class SearchesController < ApplicationController
  require 'securerandom'
  respond_to :html, :json


  def index
    if params.has_key? :looking_for_age
      params[:looking_for_age_from], params[:looking_for_age_to] = params[:looking_for_age].to_s.split("-")
    end

    params[:pillar_category_ids] ||= []

    @profile, @profile_completed =
      Search.get_data(current_user, params, session)

    respond_to do |format|

      format.html do
        @opposite_sex_results = Profile.active.where(gender: @profile.looking_for).limit 9
      end

      format.json do

        result_ids = Profile.search_result_ids params, current_user, nil
        @results = Profile.active.where(id: result_ids).paginate(page: params[:page], per_page: 5)

        render json: format_response_data(@results)
      end
    end
  end

  private


  def format_response_data(results)
    {results: results.map{|r| r.serializable_hash(scope: :search_results)},
      page: params[:page] || 1,
      total_entries: results.total_entries }
  end
end
