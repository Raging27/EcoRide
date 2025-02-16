class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.role == "driver"
      @driven_trips = current_user.driven_trips.order(start_time: :asc)
      @booked_trips = []
    elsif current_user.role == "passenger"
      @driven_trips = []
      @booked_trips = current_user.passenger_bookings.includes(:trip).map(&:trip)
    else
      @driven_trips = []
      @booked_trips = []
    end
  end
end
