class Api::SearchesController < ApplicationController
  # before_filter :authenticate_user!

  respond_to :json

  def index
    @profile, @profile_completed =
      Search.get_data(current_user, params, session, cookies)

    respond_to do |format|
      format.html do
        @opposite_sex_results = Profile.active.where(gender: @profile.looking_for).limit 9
      end

      format.json do
        @limit = 3 if !user_signed_in? || !@profile.card_verified?
        @limit ||= 5 unless @profile_completed
        result_ids = Profile.connection.select_all(
          Profile.search_conditions(params, current_user, @limit)
        ).map {|profile| profile['id']}

        @results = Profile.active.where(id: result_ids)

        unless @limit
          @results = @results.paginate page: params[:page], per_page: 5
        end

        render json: format_response_data(@results)
      end
    end
  end

  def opposite_sex
    @results = Profile.active.where(gender: params[:gender]).limit(100).select{|g| g.avatars.present? }[0..8]
    render json: @results.to_json
  end

  private
  def format_response_data(results)
    {results: results.map{|r| r.serializable_hash(scope: :search_results)},
      page: params[:page] || 1,
      total_entries: @profile_completed && @profile.card_verified? ? results.total_entries : results.size}
  end
end
