class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :driven_trips, class_name: "Trip", foreign_key: "driver_id"

  has_many :passenger_bookings, foreign_key: "passenger_id"

  has_many :vehicles, dependent: :destroy


  # helper method to get all trips
  def booked_trips
    Trip.where(id: passenger_bookings.pluck(:trip_id))
  end
end
