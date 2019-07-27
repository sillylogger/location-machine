class CoordinatesController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.json? }

  def create
    coordinate = @current_user.coordinates.create(coordinate_params)
    respond_to do |format|
      format.json { render json: coordinate.to_json}
    end
  end

  private

  def coordinate_params
    params.require(:coordinate).permit(
      :latitude,
      :longitude,
    )
  end
end
