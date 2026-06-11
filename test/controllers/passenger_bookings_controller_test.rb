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
      price: 10,
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

  test "booking credit transaction: passenger pays, driver earns price-2, admin earns 2, seats decrease" do
    trip_price = 15

    # Fresh bookable trip — isolates this test from setup's @trip / @booking
    bookable_trip = Trip.create!(
      driver: @driver,
      vehicle: @vehicle,
      start_city: "Bordeaux",
      end_city: "Toulouse",
      start_time: Time.now + 3.days,
      end_time:   Time.now + 3.days + 2.hours,
      price:           trip_price,
      seats_available: 2,
      status:          "planned"
    )

    admin = users(:admin)

    passenger_credits_before = @passenger.credits  # 20
    driver_credits_before    = @driver.credits      # 20
    admin_credits_before     = admin.credits        # 20
    seats_before             = bookable_trip.seats_available  # 2

    assert_difference "PassengerBooking.count", 1 do
      post trip_passenger_bookings_path(bookable_trip),
           params: { passenger_booking: { status: "confirmed" } }
    end

    assert_redirected_to trip_path(bookable_trip)

    @passenger.reload
    @driver.reload
    admin.reload
    bookable_trip.reload

    assert_equal passenger_credits_before - trip_price,    @passenger.credits,
                 "Passenger credits should decrease by trip price (#{trip_price})"

    assert_equal driver_credits_before + (trip_price - 2), @driver.credits,
                 "Driver credits should increase by (price - 2) = #{trip_price - 2}"

    assert_equal admin_credits_before + 2,                 admin.credits,
                 "Admin credits should increase by 2 (platform fee)"

    assert_equal seats_before - 1,                         bookable_trip.seats_available,
                 "seats_available should decrease by 1"
  end
end
