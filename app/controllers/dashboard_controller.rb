class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    case current_user.role
    when "driver"
      @vehicles = current_user.vehicles.order(created_at: :desc)
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = []
    when "passenger"
      @vehicles = []  # Les passagers n'ont pas de véhicules
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
    # If the user is a driver or both and doesn't have any vehicle, build one for the nested form.
    if ([ "driver", "both" ].include?(@user.role)) && @user.vehicles.empty?
      @user.vehicles.build
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
      # :role, # Removed for security reasons
      vehicles_attributes: [
        :id, :plate_number, :date_first_registration, :brand, :model, :color, :default_seats, :_destroy
      ]
    )
  end
end
