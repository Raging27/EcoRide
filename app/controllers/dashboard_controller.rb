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
      @pending_reviews = Review.where(status: "pending")
    when "admin"
      @total_trips    = Trip.count
      @total_users    = User.count
      @total_credits  = User.sum(:credits)
      @users          = User.all
      @trips_by_day   = Trip.group_by_day(:created_at, last: 30).count
      @credits_by_day = PassengerBooking.group_by_day(:created_at, last: 30).count
                                        .transform_values { |v| v * 2 }
    else
      @vehicles = []
      @driven_trips = []
      @booked_trips = []
    end
  end

  def edit
    @user = current_user
    # Allow drivers or those choosing "both" to manage vehicle info.
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
    permitted = params.require(:user).permit(
      :role, :smoker, :animal, :custom_preferences,
      vehicles_attributes: [
        :id, :plate_number, :date_first_registration, :brand, :model, :color, :_destroy
      ]
    )
    # Guard: users may only self-select functional roles, never privilege roles.
    if permitted[:role].present? && !%w[driver passenger both].include?(permitted[:role])
      permitted.delete(:role)
    end
    permitted
  end
end
