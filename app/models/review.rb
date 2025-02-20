class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  # Store foreign keys as integer fields
  field :trip_id,       type: Integer
  field :driver_id,     type: Integer
  field :passenger_id,  type: Integer

  field :rating,        type: Integer
  field :content,       type: String
  field :status,        type: String, default: "pending"

  # Indexes for performance
  index({ trip_id: 1 })
  index({ driver_id: 1 })
  index({ passenger_id: 1 })

  # Validations
  validates :rating, numericality: { only_integer: true, in: 1..5 }
  validates :content, presence: true

  STATUSES = [ "pending", "approved", "rejected" ]
  validates :status, inclusion: { in: STATUSES }
end
