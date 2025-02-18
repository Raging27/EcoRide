class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    case current_user.role
    when "driver"
      @vehicles = current_user.vehicles.order(created_at: :desc)
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = []
    when "passenger"
      @vehicles = []  # Passengers don't have vehicles
      @driven_trips = []
      @booked_trips = current_user.passenger_bookings.includes(:trip).map(&:trip)
    when "both"
      @vehicles = current_user.vehicles.order(created_at: :desc)
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = current_user.passenger_bookings.includes(:trip).map(&:trip)
    when "employee"
      # For employees, load data such as pending reviews or issues
      @pending_reviews = Review.where(status: "pending")
      # You could also load trips flagged for review or issues, if applicable
    when "admin"
      # For administrators, load system-wide metrics
      @total_trips = Trip.count
      @total_users = User.count
      @total_credits = User.sum(:credits)
      # Additional admin metrics can be added here
    else
      @vehicles = []
      @driven_trips = []
      @booked_trips = []
    end
  end

  def edit
    @user = current_user
    # Only allow drivers or users choosing "both" to edit vehicle information.
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
    # For security reasons, we are not allowing direct changes to the role via the dashboard.
    params.require(:user).permit(
      vehicles_attributes: [
        :id, :plate_number, :date_first_registration, :brand, :model, :color, :default_seats, :_destroy
      ]
    )
  end
end
