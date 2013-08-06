class Search
  def self.get_data(current_user, params, session, cookies)
    if current_user.present?
      params[:pillar_category_ids] ||= []

      @profile = current_user.profile

      is_completed = @profile.pillars.present?
    else
      session[:guest_hash] ||= SecureRandom.uuid

      @profile = Profile.new({
        looking_for: cookies[:looking_for],
        gender: cookies[:gender],
        in_or_around: cookies[:in_or_around],
        looking_for_age: cookies[:looking_for_age],
      })

      is_completed = false
    end

    [@profile, is_completed]
  end
end
