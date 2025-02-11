class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role == "passenger"
      # Load passenger bookings and eager load associated trips for efficiency.
      @bookings = current_user.passenger_bookings.includes(:trip)
    else
      # For drivers, list trips they are driving.
      @trips = current_user.driven_trips
    end
  end
end
