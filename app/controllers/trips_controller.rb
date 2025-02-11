class TripsController < ApplicationController
  # GET /trips
  def index
    @trips = Trip.all

    # Filter by start city if provided (case-insensitive)
    if params[:start_city].present?
      @trips = @trips.where("start_city ILIKE ?", "%#{params[:start_city]}%")
    end

    # Filter by end city if provided (case-insensitive)
    if params[:end_city].present?
      @trips = @trips.where("end_city ILIKE ?", "%#{params[:end_city]}%")
    end

    # Filter by minimum price if provided
    if params[:min_price].present?
      @trips = @trips.where("price >= ?", params[:min_price])
    end

    # Filter by maximum price if provided
    if params[:max_price].present?
      @trips = @trips.where("price <= ?", params[:max_price])
    end
  end

  # GET /trips/:id
  def show
    @trip = Trip.find(params[:id])
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    # Assign the current user as the driver; ensure you have user authentication set up
    @trip.driver = current_user

    if @trip.save
      redirect_to @trip, notice: "Trip was successfully created."
    else
      # Renders the 'new' view again with errors
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def trip_params
    params.require(:trip).permit(:vehicle_id, :start_city, :end_city, :start_time, :end_time, :price, :seats_available, :status)
  end
end
