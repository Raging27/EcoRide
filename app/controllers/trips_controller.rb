class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: [ :show, :start, :finish, :edit, :update, :destroy ]

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
    # @trip is set in the before_action
  end

  # GET /trips/new
  def new
    unless current_user.role == "driver" || current_user.role == "both"
      redirect_to trips_path, alert: "Seuls les conducteurs peuvent créer des voyages." and return
    end

    @trip = Trip.new
    # Prepare nested vehicle attributes for a new vehicle option
    @trip.build_vehicle
  end

  # POST /trips
  def create
    unless current_user.role == "driver" || current_user.role == "both"
      redirect_to trips_path, alert: "Seuls les conducteurs peuvent créer des voyages." and return
    end

    if current_user.credits < 2
      redirect_to trips_path, alert: "Crédits insuffisants pour créer un voyage." and return
    end

    if params[:trip][:vehicle_option] == "new"
      # When adding a new vehicle, ignore the vehicle_id and use nested vehicle attributes.
      @trip = Trip.new(trip_params.except(:vehicle_id))
      if @trip.vehicle.present?
        # Associate the new vehicle with the current user.
        @trip.vehicle.user = current_user
      end
    else
      # Use the existing vehicle; ignore nested vehicle attributes and the vehicle_option.
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

  # PATCH /trips/:id/start
  def start
    if @trip.driver == current_user
      if @trip.update(status: "in_progress")
        redirect_to @trip, notice: "Voyage démarré avec succès."
      else
        redirect_to @trip, alert: "Impossible de démarrer le voyage."
      end
    elsif current_user.role == "passenger" && current_user.credits >= 2
      if current_user.passenger_bookings.create!(trip: @trip, status: "confirmed") && @trip.update(status: "in_progress")
        current_user.update!(credits: current_user.credits - 2)
        redirect_to @trip, notice: "Voyage démarré avec succès."
      else
        redirect_to @trip, alert: "Impossible de démarrer le voyage."
      end
    else
      redirect_to @trip, alert: "Vous n'êtes pas autorisé à démarrer ce voyage."
    end
  end


  # PATCH /trips/:id/finish
  def finish
    if @trip.driver == current_user
      if @trip.update(status: "finished")
        redirect_to @trip, notice: "Voyage terminé avec succès."
      else
        redirect_to @trip, alert: "Impossible de terminer le voyage."
      end
    else
      redirect_to @trip, alert: "Vous n'êtes pas autorisé à terminer ce voyage."
    end
  end

  def edit
    unless @trip.driver == current_user && @trip.status == "planned"
      redirect_to @trip, alert: "Vous ne pouvez modifier que vos voyages planifiés."
    end
  end

  def update
    unless @trip.driver == current_user && @trip.status == "planned"
      redirect_to @trip, alert: "Vous ne pouvez modifier que vos voyages planifiés."
      return
    end

    if @trip.update(trip_params.except(:vehicle_attributes))
      redirect_to @trip, notice: "Voyage mis à jour avec succès."
    else
      flash.now[:alert] = "Voyage non mis à jour."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @trip.driver == current_user && @trip.status == "planned"
      redirect_to @trip, alert: "Vous ne pouvez supprimer que vos voyages planifiés."
      return
    end

    @trip.destroy
    redirect_to trips_path, notice: "Voyage supprimé avec succès."
  end

  def filter
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

    render json: @trips.as_json(
      only: [ :id, :start_city, :end_city, :price, :seats_available, :start_time, :driver_id ]
    )
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    permitted = [
      :vehicle_id, :start_city, :end_city, :start_time, :end_time,
      :price, :seats_available, :status, :vehicle_option
    ]
    permitted << { vehicle_attributes: [ :plate_number, :date_first_registration, :brand, :model, :color, :electric ] }
    params.require(:trip).permit(permitted)
  end
end
