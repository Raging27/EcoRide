require "test_helper"

class PassengerBookingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @passenger = users(:two)
    sign_in @passenger

    @driver = users(:one)

    @vehicle = @driver.vehicles.first || Vehicle.create!(
      user: @driver,
      plate_number: "ABC123",
      date_first_registration: Date.today - 2.years,
      brand: "Toyota",
      model: "Corolla",
      color: "Blue",
      electric: false
    )

    @trip = trips(:one) || Trip.create!(
      driver: @driver,
      vehicle: @vehicle,
      start_city: "Paris",
      end_city: "Lyon",
      start_time: Time.now + 1.day,
      end_time: Time.now + 1.day + 2.hours,
      price: 50,
      seats_available: 4,
      status: "planned"
    )

    @booking = PassengerBooking.create!(
      trip: @trip,
      passenger: @passenger,
      status: "confirmed"
    )
  end

  test "should create passenger booking" do
    # Create a new trip for booking creation to avoid conflicts with the existing booking
    new_trip = Trip.create!(
      driver: @driver,
      vehicle: @vehicle,
      start_city: "Marseille",
      end_city: "Nice",
      start_time: Time.now + 2.days,
      end_time: Time.now + 2.days + 2.hours,
      price: 60,
      seats_available: 3,
      status: "planned"
    )

    assert_difference("PassengerBooking.count", 1) do
      post trip_passenger_bookings_path(new_trip),
          params: { passenger_booking: { status: "confirmed" } }
    end

    assert_redirected_to trip_path(new_trip)
  end

  test "should destroy passenger booking" do
    assert_difference("PassengerBooking.count", -1) do
      delete passenger_booking_path(@booking)
    end

    assert_redirected_to trip_path(@trip)
  end
end
