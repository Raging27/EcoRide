class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :driven_trips, class_name: "Trip", foreign_key: "driver_id", dependent: :destroy
  has_many :passenger_bookings, foreign_key: "passenger_id", dependent: :destroy
  has_many :vehicles, dependent: :destroy

  # Allow drivers (or users choosing "both") to manage their vehicles via nested attributes
  accepts_nested_attributes_for :vehicles, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :pseudo, presence: true
  validates :credits, numericality: { greater_than_or_equal_to: 0 }
  validates :role, inclusion: { in: %w[driver passenger both],
    message: "doit être 'driver', 'passenger' ou 'both'" }

  # Helper method to retrieve trips booked as a passenger
  def booked_trips
    Trip.where(id: passenger_bookings.pluck(:trip_id))
  end
end
