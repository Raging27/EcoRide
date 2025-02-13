require "test_helper"

class PassengerBookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get passenger_bookings_create_url
    assert_response :success
  end

  test "should get destroy" do
    get passenger_bookings_destroy_url
    assert_response :success
  end
end
