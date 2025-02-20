class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :driven_trips, class_name: "Trip", foreign_key: "driver_id", dependent: :destroy
  has_many :passenger_bookings, foreign_key: "passenger_id", dependent: :destroy
  has_many :vehicles, dependent: :destroy

  accepts_nested_attributes_for :vehicles, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :pseudo, presence: true
  validates :credits, numericality: { greater_than_or_equal_to: 0 }
  validates :role, inclusion: { in: %w[driver passenger both employee admin],
    message: "doit être 'driver', 'passenger', 'both', 'employee' ou 'admin'" }

  validate :password_complexity, if: :password_required?

  def booked_trips
    Trip.where(id: passenger_bookings.pluck(:trip_id))
  end

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end


  def password_complexity
    return if password.blank?
    unless password.match(/(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}/)
      errors.add :password, "must include at least one uppercase letter, one lowercase letter, one digit, and one special character, and be at least 8 characters long"
    end
  end
end
