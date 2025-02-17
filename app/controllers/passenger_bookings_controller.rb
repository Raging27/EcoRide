class PassengerBookingsController < ApplicationController
  before_action :authenticate_user!

  # POST /trips/:trip_id/passenger_bookings
  def create
    @trip = Trip.find(params[:trip_id])

    # Prevent drivers from booking their own trip
    if @trip.driver == current_user
      redirect_to trip_path(@trip), alert: "Les conducteurs ne peuvent pas réserver leur propre voyage." and return
    end

    # Check for seat availability
    if @trip.seats_available <= 0
      redirect_to trip_path(@trip), alert: "Aucune place disponible pour ce voyage." and return
    end

    booking_cost = 1

    # Check if the passenger has enough credits
    if current_user.credits < booking_cost
      redirect_to trip_path(@trip), alert: "Vous n'avez pas assez de crédits pour réserver ce voyage." and return
    end

    # Prevent duplicate bookings for the same trip
    if PassengerBooking.exists?(trip: @trip, passenger: current_user)
      redirect_to trip_path(@trip), alert: "Vous avez déjà réservé ce voyage." and return
    end

    ActiveRecord::Base.transaction do
      @booking = PassengerBooking.create!(trip: @trip, passenger: current_user, status: "confirmed")
      @trip.update!(seats_available: @trip.seats_available - 1)
      current_user.update!(credits: current_user.credits - booking_cost)
    end

    redirect_to trip_path(@trip), notice: "Réservation effectuée avec succès. #{booking_cost} crédit a été déduit."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Erreur lors de la réservation du voyage #{@trip.id}: #{e.message}")
    redirect_to trip_path(@trip), alert: "Échec de la réservation : #{e.message}"
  end

  # DELETE /passenger_bookings/:id
  def destroy
    @booking = PassengerBooking.find(params[:id])
    @trip = @booking.trip

    # Ensure the current user is the owner of the booking
    unless @booking.passenger == current_user
      redirect_to trip_path(@trip), alert: "Vous n'êtes pas autorisé à annuler cette réservation." and return
    end

    ActiveRecord::Base.transaction do
      # Refund the booking cost
      current_user.update!(credits: current_user.credits + 1)
      # Increment available seats for the trip
      @trip.update!(seats_available: @trip.seats_available + 1)
      @booking.destroy!
    end

    redirect_to trip_path(@trip), notice: "Réservation annulée avec succès."
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Erreur lors de l'annulation de la réservation #{@booking.id}: #{e.message}")
    redirect_to trip_path(@trip), alert: "Échec de l'annulation de la réservation : #{e.message}"
  end
end
