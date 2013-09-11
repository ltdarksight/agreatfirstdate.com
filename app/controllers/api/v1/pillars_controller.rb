class Api::V1::PillarsController < Api::V1::BaseController
  def show
    render json: Pillar.find(params[:id]).to_json(scope: :profile), status: 200
  end
end