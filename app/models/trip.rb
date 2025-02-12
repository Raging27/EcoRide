class Trip < ApplicationRecord
  belongs_to :driver, class_name: "User"
  belongs_to :vehicle
  has_many :passenger_bookings, dependent: :destroy

  validates :seats_available, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 8
  }

  def reviews
    Review.where(trip_id: id)
  end

  # Before destroying trip, delete its reviews from MongoDB.
  before_destroy :cleanup_reviews

  private

  def cleanup_reviews
    Review.where(trip_id: id).delete_all
  end
end
