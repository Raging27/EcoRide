class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # As a driver, a user can have many trips
  has_many :driven_trips, class_name: "Trip", foreign_key: "driver_id"

  # As a passenger, a user can have many passenger bookings
  has_many :passenger_bookings, foreign_key: "passenger_id"

  # Optional: If you want, you can define a helper method to get all trips
  def booked_trips
    Trip.where(id: passenger_bookings.pluck(:trip_id))
  end
end
