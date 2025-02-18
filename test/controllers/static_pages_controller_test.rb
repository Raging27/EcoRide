require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get contact_path
    assert_response :success
  end

  test "should get mentions_legales" do
    get mentions_legales_path
    assert_response :success
  end
end
