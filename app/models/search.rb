class Search
  def self.get_data(current_user, params, session, cookies)
    if current_user.present?
      params[:pillar_category_ids] ||= []

      @profile = current_user.profile

      if @profile.search_cache && @profile.search_cache.created_at < Date.today
        @profile.search_cache.delete
        @profile.reload
      end
      @search_cache = @profile.search_cache || @profile.build_search_cache

      cached_pillar_category_ids = params[:pillar_category_ids].map(&:to_i).sort
      if cached_pillar_category_ids != @search_cache.pillar_ids.sort
        @search_cache.pillar_ids = cached_pillar_category_ids
        @search_cache.result_ids = []
      end

      is_completed = @profile.pillars.present?
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

      is_completed = false
    end

    [@profile, @search_cache, is_completed]
  end
end
