class CoordinatorsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    coordinator = @current_user.coordinators.create(coordinator_params)
    respond_to do |format|
      format.json { render json: coordinator.to_json}
    end
  end

  private

  def coordinator_params
    params.require(:coordinator).permit(
      :latitude,
      :longitude,
    )
  end
end
