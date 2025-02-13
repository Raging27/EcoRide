class PassengerBookingsController < ApplicationController
  before_action :authenticate_user!

  # POST /trips/:trip_id/passenger_bookings
  def create
    @trip = Trip.find(params[:trip_id])

    # Check for available seats
    if @trip.seats_available <= 0
      redirect_to trip_path(@trip), alert: "No seats available for this trip." and return
    end

    # Define booking cost (adjust as needed)
    booking_cost = 1

    # Ensure the current user (passenger) has enough credits
    if current_user.credits < booking_cost
      redirect_to trip_path(@trip), alert: "You do not have enough credits to book this trip." and return
    end

    ActiveRecord::Base.transaction do
      @booking = PassengerBooking.create!(trip: @trip, passenger: current_user, status: "confirmed")

      @trip.update!(seats_available: @trip.seats_available - 1)

      # Deduct the booking cost from the user's credits
      current_user.update!(credits: current_user.credits - booking_cost)
    end

    redirect_to trip_path(@trip), notice: "Successfully booked the trip."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to trip_path(@trip), alert: "Booking failed: #{e.message}"
  end

  # DELETE /passenger_bookings/:id
  def destroy
    @booking = PassengerBooking.find(params[:id])
    @trip = @booking.trip

    ActiveRecord::Base.transaction do
      # Refund the booking cost to the user
      current_user.update!(credits: current_user.credits + 1)
      # Increment the trip's available seats
      @trip.update!(seats_available: @trip.seats_available + 1)
      # Remove the booking record
      @booking.destroy!
    end

    redirect_to trip_path(@trip), notice: "Booking canceled."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to trip_path(@trip), alert: "Cancellation failed: #{e.message}"
  end
end
