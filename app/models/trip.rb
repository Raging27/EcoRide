class Trip < ApplicationRecord
  attr_accessor :vehicle_option

  belongs_to :driver, class_name: "User"
  belongs_to :vehicle
  has_many :passenger_bookings, dependent: :destroy

  # Allow nested attributes for creating a new vehicle
  accepts_nested_attributes_for :vehicle, reject_if: :all_blank

  # Validations for essential fields
  validates :start_city, :end_city, :start_time, :end_time, :price, :status, presence: true

  validates :seats_available, numericality: { only_integer: true,
                                                greater_than_or_equal_to: 1,
                                                less_than_or_equal_to: 8 }

  validates_associated :vehicle, if: -> { vehicle_option == "new" }

  # Manually fetch reviews from MongoDB
  def reviews
    Review.where(trip_id: id)
  end

  # Callback: before destroying a trip, clean up its reviews from MongoDB
  before_destroy :cleanup_reviews

  private

  def cleanup_reviews
    reviews.delete_all
  end
end
