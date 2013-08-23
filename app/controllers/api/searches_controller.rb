class Api::SearchesController < ApplicationController
  # before_filter :authenticate_user!

  respond_to :json

  def index
    params[:pillar_category_ids] ||= []

    @profile, @profile_completed =
      Search.get_data(current_user, params, session)

    result_ids = Profile.search_result_ids(params, current_user, nil)

    @results = Profile.active.where(id: result_ids).paginate page: params[:page], per_page: 5
    render json: format_response_data(@results)

  end

  def opposite_sex
    @results = Profile.active.where(gender: params[:gender]).limit(100).select{|g| g.avatars.present? }[0..8]
    render json: @results.to_json
  end

  private
  def view_profile
    @view_profile ||
      begin
        @view_profile = Profile.active.find_by_id(session[:view_profile_id]) if session[:view_profile_id]
        session.delete(:view_profile_id)
      end

    @view_profile
  end
  def format_response_data(results)
    result_items = results.map{|r| r.serializable_hash(scope: :search_results) }
    result_items.insert(2, view_profile.serializable_hash(scope: :search_results)) if view_profile
    {
      results: result_items,
      page: (params[:page] || 1),
      total_entries: results.total_entries
    }
  end
end
