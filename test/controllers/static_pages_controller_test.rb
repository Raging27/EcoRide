require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get static_pages_contact_url
    assert_response :success
  end

  test "should get mentions_legales" do
    get static_pages_mentions_legales_url
    assert_response :success
  end
end
