class Api::SearchesController < ApplicationController
  # before_filter :authenticate_user!

  respond_to :json

  def index
    @profile_completed =
      if user_signed_in?
        params[:pillar_category_ids] ||= []

        @profile = current_user.profile

        @profile.search_cache.delete if @profile.search_cache && @profile.search_cache.created_at < Date.today
        @search_cache = @profile.search_cache || @profile.build_search_cache

        if @profile.pillar_category_ids.sort != @search_cache.pillar_ids.sort
          @search_cache.pillar_ids = @profile.pillar_category_ids
          @search_cache.result_ids = []
        end

        @profile.pillars.count == 4
      else
        SearchCache.guest_caches.destroy_all #(['created_at < ?', Date.today])
        session[:guest_hash] ||= SecureRandom.uuid
        @search_cache = SearchCache.find_or_create_by_guest_hash(session[:guest_hash])

        @profile = Profile.new({
                                 looking_for: cookies[:looking_for],
                                 gender: cookies[:gender],
                                 in_or_around: cookies[:in_or_around],
                                 looking_for_age: cookies[:looking_for_age],
                               })

        false
      end

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
