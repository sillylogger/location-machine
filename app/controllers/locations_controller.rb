class LocationsController < ApplicationController
  before_action :authenticate_user!,  except: [:index, :show]
  before_action :set_location,        only:   [:edit, :update, :destroy]
  before_action :get_user_coordinate, only: [:index]

  protect_from_forgery except: :index

  # GET /
  def index
    if params[:query].present?
      service = GetLocationsBySearch.call({ query: params[:query], bounds: bounds_params })
      @search_documents = service.search_documents
      @locations = service.locations
      @search_documents = @search_documents.map do |document|
        document.reload
        document.distance = document.distance_to(@user_coordinate.to_latlng)
        document
      end
    else
      @locations = LocationQuery.new({ query: params[:query], bounds: bounds_params }).match_in_bounds
    end

    @latest_coordinate = @current_user.latest_coordinate if @current_user

    respond_to do |format|
      format.html
      format.json { render json: @locations.to_json }
      format.js { render layout: false }
    end
  end

  # GET /locations/1
  def show
    @location = Location.find params[:id]
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.items.build
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  def create
    @location = current_user.locations.new(location_params)
    if @location.save
      redirect_to @location, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      redirect_to @location, notice: 'Location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
    redirect_to root_path, notice: 'Location was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = current_user.locations.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(
      :latitude,
      :longitude,
      :name,
      :address,
      :description,
      items_attributes: [
        :id,
        :image,
        :name,
        :price,
        :description
      ]
    )
  end

  def bounds_params
    [params[:bounds][:south_west], params[:bounds][:north_east]] if params[:bounds].present?
  end
end
