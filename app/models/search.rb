class Search
  def self.get_data(current_user, params, session)
    if current_user.present?
      @profile = current_user.profile

      is_completed = @profile.pillars.present?
    else
      session[:guest_hash] ||= SecureRandom.uuid

      @profile = Profile.new({
        looking_for: params[:looking_for],
        gender: params[:gender],
        in_or_around: params[:in_or_around],
        looking_for_age: params[:looking_for_age],
      })

      is_completed = false
    end

    [@profile, is_completed]
  end
end
