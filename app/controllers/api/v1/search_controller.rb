class Api::V1::SearchController < Api::V1::BaseController
  def index
    params[:pillar_category_ids] ||= []

    profile, profile_completed =
      Search.get_data(current_user, params, session)

    result_ids = Profile.search_result_ids(params, current_user, (user_signed_in? ? nil : 3) )

    results = Profile.active.where(id: result_ids).paginate(page: params[:page], per_page: (user_signed_in? ? nil : 3))
    render json: format_response_data(results)
  end
end