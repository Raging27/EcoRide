class TripsController < ApplicationController
  before_action :authenticate_user!

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

    # New filter: eco-friendly trips (electric vehicles)
    if params[:eco_friendly].present? && params[:eco_friendly] == "true"
      # Make sure to join the vehicles table so we can filter on its attributes
      @trips = @trips.joins(:vehicle).where(vehicles: { electric: true })
    end

    # New filter: maximum travel duration (in hours)
    if params[:max_duration].present?
      max_duration = params[:max_duration].to_f
      # Calculate duration in hours: (end_time - start_time) in seconds divided by 3600
      @trips = @trips.where("EXTRACT(EPOCH FROM (end_time - start_time)) / 3600 <= ?", max_duration)
    end
  end

  # GET /trips/:id
  def show
    @trip = Trip.find(params[:id])
  end

  # GET /trips/new
  def new
    # Ensure only drivers can create trips
    unless current_user.role == "driver"
      redirect_to trips_path, alert: "Only drivers can create trips." and return
    end

    @trip = Trip.new
  end

  # POST /trips
  def create
    # Ensure only drivers can create trips
    unless current_user.role == "driver"
      redirect_to trips_path, alert: "Only drivers can create trips." and return
    end

    # Check if the driver has at least 2 credits (platform fee)
    if current_user.credits < 2
      redirect_to trips_path, alert: "Insufficient credits to create a trip." and return
    end

    @trip = Trip.new(trip_params)
    @trip.driver = current_user

    ActiveRecord::Base.transaction do
      if @trip.save
        current_user.update!(credits: current_user.credits - 2)
        redirect_to @trip, notice: "Trip was successfully created. 2 credits have been deducted."
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new, status: :unprocessable_entity, alert: "Trip creation failed: #{e.message}"
  end

  private

  def trip_params
    params.require(:trip).permit(:vehicle_id, :start_city, :end_city, :start_time, :end_time, :price, :seats_available, :status)
  end
end
