class Trip < ApplicationRecord
  belongs_to :driver, class_name: "User"

  belongs_to :vehicle

  has_many :passenger_bookings, dependent: :destroy

  def reviews
    Review.where(trip_id: id)
  end
end
