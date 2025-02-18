class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Load user's trips and vehicles based on their role
    case current_user.role
    when "driver"
      @vehicles = current_user.vehicles.order(created_at: :desc)
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = []
    when "passenger"
      @vehicles = [] # Passengers don't have vehicles
      @driven_trips = []
      @booked_trips = current_user.passenger_bookings.includes(:trip).map(&:trip)
    when "both"
      @vehicles = current_user.vehicles.order(created_at: :desc)
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = current_user.passenger_bookings.includes(:trip).map(&:trip)
    else
      @vehicles = []
      @driven_trips = []
      @booked_trips = []
    end
  end

  def edit
    @user = current_user
    # If the user is a driver or both and they don't have any vehicles,
    # build one for the nested form.
    if ([ "driver", "both" ].include?(@user.role)) && @user.vehicles.empty?
      @user.build_vehicle
    end
  end

  def update
    @user = current_user
    if @user.update(user_dashboard_params)
      redirect_to dashboard_path, notice: "Profil mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_dashboard_params
    params.require(:user).permit(
      :role, :accepts_smokers, :accepts_animals,
      vehicles_attributes: [
        :id, :plate_number, :date_first_registration, :brand, :model, :color, :default_seats, :_destroy
      ]
    )
  end
end
