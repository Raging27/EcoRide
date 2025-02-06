class PassengerBooking < ApplicationRecord
  belongs_to :trip
  belongs_to :passenger, class_name: "User"
end
