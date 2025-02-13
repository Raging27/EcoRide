require "test_helper"

class TripsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Sign in using an existing user fixture; adjust the key if needed.
    @user = users(:one)
    sign_in @user

    # Ensure the user has at least one vehicle.
    @vehicle = @user.vehicles.first || Vehicle.create!(
      user: @user,
      plate_number: "ABC123",
      date_first_registration: Date.today - 2.years,
      brand: "Toyota",
      model: "Corolla",
      color: "Blue",
      electric: false
    )

    # Use an existing trip fixture (if available); otherwise, create one.
    @trip = trips(:one) || Trip.create!(
      driver: @user,
      vehicle: @vehicle,
      start_city: "Paris",
      end_city: "Lyon",
      start_time: Time.now + 1.day,
      end_time: Time.now + 1.day + 2.hours,
      price: 50,
      seats_available: 4,
      status: "planned"
    )
  end

  test "should get index" do
    get trips_path
    assert_response :success
  end

  test "should get new" do
    get new_trip_path
    assert_response :success
  end

  test "should show trip" do
    get trip_path(@trip)
    assert_response :success
  end

  test "should create trip" do
    assert_difference("Trip.count", 1) do
      post trips_path, params: { trip: {
        vehicle_id: @vehicle.id,
        start_city: "Marseille",
        end_city: "Nice",
        start_time: Time.now + 1.day,
        end_time: Time.now + 1.day + 2.hours,
        price: 60,
        seats_available: 4,
        status: "planned"
      } }
    end
    assert_redirected_to trip_path(Trip.last)
  end
end
