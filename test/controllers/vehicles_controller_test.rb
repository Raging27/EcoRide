require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # Use an existing user fixture; ensure your test/fixtures/users.yml has an entry with the key "one"
    @user = users(:one)
    sign_in @user

    @vehicle_params = {
      plate_number: "XYZ789",
      date_first_registration: Date.today - 3.years,
      brand: "Toyota",
      model: "Camry",
      color: "White",
      electric: false
    }
  end

  test "should get index" do
    get vehicles_path
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_path
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference("Vehicle.count", 1) do
      post vehicles_path, params: { vehicle: @vehicle_params }
    end
    assert_redirected_to vehicles_path  # Adjust if your controller redirects elsewhere after creation
  end
end
