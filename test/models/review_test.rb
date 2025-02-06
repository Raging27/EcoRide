require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "should not save review without content" do
    review = Review.new(trip_id: 1, driver_id: 1, passenger_id: 1, rating: 5)
    assert_not review.save, "Saved the review without content"
  end

  test "should only allow ratings between 1 and 5" do
    # This review has an invalid rating (6)
    review = Review.new(trip_id: 1, driver_id: 1, passenger_id: 1, rating: 6, content: "Test review")
    assert_not review.valid?, "Review with a rating outside 1-5 is considered valid"
  end
end
