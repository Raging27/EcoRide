class Trip < ApplicationRecord
  belongs_to :driver, class_name: "User"
  belongs_to :vehicle
  has_many :passenger_bookings, dependent: :destroy

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
