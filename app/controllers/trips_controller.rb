class TripsController < ApplicationController
  before_action :authenticate_user!

  # GET /trips
  def index
    @trips = Trip.all

    if params[:start_city].present?
      @trips = @trips.where("start_city ILIKE ?", "%#{params[:start_city]}%")
    end

    if params[:end_city].present?
      @trips = @trips.where("end_city ILIKE ?", "%#{params[:end_city]}%")
    end

    if params[:min_price].present?
      @trips = @trips.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      @trips = @trips.where("price <= ?", params[:max_price])
    end

    if params[:eco_friendly].present? && params[:eco_friendly] == "true"
      @trips = @trips.joins(:vehicle).where(vehicles: { electric: true })
    end

    if params[:max_duration].present?
      max_duration = params[:max_duration].to_f
      @trips = @trips.where("EXTRACT(EPOCH FROM (end_time - start_time)) / 3600 <= ?", max_duration)
    end

    if params[:date].present?
      begin
        search_date = Date.parse(params[:date])
        @trips = @trips.where("DATE(start_time) = ?", search_date)
      rescue ArgumentError
        flash.now[:alert] = "La date fournie n'est pas valide."
      end
    end
  end

  # GET /trips/:id
  def show
    @trip = Trip.find(params[:id])
  end

  # GET /trips/new
  def new
    unless current_user.role == "driver"
      redirect_to trips_path, alert: "Seuls les conducteurs peuvent créer des voyages." and return
    end

    @trip = Trip.new
    # Build nested vehicle attributes for the "new vehicle" option
    @trip.build_vehicle
  end

  # POST /trips
  def create
    unless current_user.role == "driver"
      redirect_to trips_path, alert: "Seuls les conducteurs peuvent créer des voyages." and return
    end

    if current_user.credits < 2
      redirect_to trips_path, alert: "Crédits insuffisants pour créer un voyage." and return
    end

    # Determine which vehicle option was selected
    if params[:trip][:vehicle_option] == "new"
      # When adding a new vehicle, ignore the vehicle_id parameter.
      @trip = Trip.new(trip_params.except(:vehicle_id))
      # Associate the new vehicle with the current user if present.
      @trip.vehicle.user = current_user if @trip.vehicle.present?
    else
      # Otherwise, use the existing vehicle and ignore nested vehicle attributes and vehicle_option.
      @trip = Trip.new(trip_params.except(:vehicle_attributes, :vehicle_option))
    end

    @trip.driver = current_user

    ActiveRecord::Base.transaction do
      if @trip.save
        current_user.update!(credits: current_user.credits - 2)
        redirect_to @trip, notice: "Voyage créé avec succès. 2 crédits ont été déduits."
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Erreur lors de la création du voyage : #{e.message}")
    render :new, status: :unprocessable_entity, alert: "La création du voyage a échoué : #{e.message}"
  end

  private

  def trip_params
    permitted = [
      :vehicle_id, :start_city, :end_city, :start_time, :end_time,
      :price, :seats_available, :status, :vehicle_option
    ]
    permitted << { vehicle_attributes: [ :plate_number, :date_first_registration, :brand, :model, :color, :electric ] }
    params.require(:trip).permit(permitted)
  end
end
