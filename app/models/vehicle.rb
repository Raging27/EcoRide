class Vehicle < ApplicationRecord
  belongs_to :user

  validates :plate_number, presence: true, uniqueness: true
  validates :date_first_registration, presence: true
  validates :brand, presence: true
  validates :model, presence: true
  validates :color, presence: true
end
